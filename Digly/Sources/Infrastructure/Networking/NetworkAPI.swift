import Foundation

final class NetworkAPI {
    private let session = URLSession.shared
    
    func refreshToken() async throws -> ReissueResult {
        guard let refreshToken = KeychainManager.shared.getRefreshToken(),
              let memberId = getCurrentMemberId() else {
            throw APIError.unauthorized
        }
        // Spec: reissue uses Authorization header with refreshToken only (no body)
        _ = memberId // kept in case of future use
        let response: ReissueResult = try await request(AuthEndpoint.postReissue(refreshToken))
        
        KeychainManager.shared.saveTokens(response.accessToken, response.refreshToken)
        
        return response
    }
    
    func request<T: Decodable>(
        _ endpoint: any APIEndpoint,
        parameters: [String: Any]? = nil,
        queryParameters: [String: String]? = nil
    ) async throws -> T {
        var urlString = APIConstants.baseUrl + endpoint.path
        
        do {
            guard NetworkManager.shared.isConnected else {
                throw APIError.networkError
            }
            
            if let queryParams = queryParameters, !queryParams.isEmpty {
                var components = URLComponents(string: urlString)
                components?.queryItems = queryParams.map {
                    URLQueryItem(name: $0.key, value: $0.value)
                }
                urlString = components?.url?.absoluteString ?? urlString
            }
            
            guard let url = URL(string: urlString) else {
                throw APIError.invalidURL
            }
            
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = endpoint.method.rawValue
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            switch endpoint.tokenType {
            case .none:
                break
            case .accessToken:
                guard let token = KeychainManager.shared.getAccessToken() else {
                    throw APIError.unauthorized
                }
                urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            case .refreshToken:
                guard let token = KeychainManager.shared.getRefreshToken() else {
                    throw APIError.unauthorized
                }
                urlRequest.setValue("\(token)", forHTTPHeaderField: "Authorization")
            case .custom(let key, let value):
                urlRequest.setValue(value, forHTTPHeaderField: key)
            }
            
            if let parameters = parameters {
                let jsonData = try JSONSerialization.data(withJSONObject: parameters)
                urlRequest.httpBody = jsonData
            }
            
            let (data, response) = try await session.data(for: urlRequest)
            
            if APIConstants.isServerDevelopment {
                print("🛜 API Request: \(endpoint.method.rawValue) - \(urlString)")
                if let params = parameters {
                    print("Body Parameters: \(params)")
                }
                if let queryParams = queryParameters, !queryParams.isEmpty {
                    print("Query Parameters: \(queryParams)")
                }
                print("▶️ Response: \(String(data: data, encoding: .utf8) ?? "Unable to decode response")")
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw APIError.notFound
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                if httpResponse.statusCode == 424 {
                    do {
                        _ = try await refreshToken()
                        return try await request(endpoint, parameters: parameters, queryParameters: queryParameters)
                    } catch {
                        throw APIError.unauthorized
                    }
                }
                
                if let errorResponse = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let message = errorResponse["message"] as? String {
                    throw APIError.from(statusCode: httpResponse.statusCode, message: message)
                } else {
                    throw APIError.from(statusCode: httpResponse.statusCode)
                }
            }
            
            let decoder = JSONDecoder.diglyDecoder
            return try decoder.decode(T.self, from: data)
        } catch {
            print(error)
            
            if let apiError = error as? APIError {
                if apiError.isAutoHandled {
                    if case AuthEndpoint.postLogin = endpoint, apiError == .unauthorized {
                        throw apiError
                    } else {
                        handleError(apiError)
                    }
                } else {
                    print(apiError)
                    throw apiError
                }
            }
            
            print(error)
            throw APIError(error: error)
        }
    }
    
    private func handleError(_ error: APIError) {
        Task { @MainActor in
            ToastManager.shared.show(.errorWithMessage(error.localizedDescription))
            
            switch error {
            case .unauthorized:
                AuthManager.shared.logout()
            default:
                 print(error)
            }
        }
    }
    
    private func getCurrentMemberId() -> Int? {
        return UserDefaults.standard.object(forKey: "currentMemberId") as? Int
    }
}
