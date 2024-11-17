//
//  NetworkServiceProtocol.swift
//  digly
//
//  Created by Neoself on 11/2/24.
//


//
//  ServiceProtocols.swift
//  tyte
//
//  Created by Neoself on 10/31/24.
//
import Combine
import Alamofire

protocol NetworkServiceProtocol {
    func request<T: Decodable>(
        _ endpoint: APIEndpoint,
        method: HTTPMethod,
        parameters: Parameters?
    ) -> AnyPublisher<T, APIError>
    
    func requestWithoutAuth<T: Decodable>(_ endpoint: APIEndpoint,
                                          method: HTTPMethod,
                                          parameters: Parameters?) -> AnyPublisher<T, APIError>
}

protocol AuthServiceProtocol {
    func socialLogin(idToken: String, provider:String) -> AnyPublisher<LoginResponse, APIError>
    func login(email: String, password: String) -> AnyPublisher<LoginResponse, APIError>
    func signUp(email: String, username: String, password: String) -> AnyPublisher<LoginResponse, APIError>
//    func validateToken(_ token: String) -> AnyPublisher<Bool, APIError>
//    func deleteAccount(_ email: String) -> AnyPublisher<String, APIError>
}
