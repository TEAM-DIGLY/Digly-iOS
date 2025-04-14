//
//  DGNetworkService.swift
//  Digly
//
//  Created by 윤동주 on 3/9/25.
//

import Foundation

class DGNetworkService: APIService {
    func get<T>(endpoint: EndPoint) async throws -> T where T : Decodable {
        try await APIClient.shared.getRequest(endpoint: endpoint)
    }
    
    func post<T, U>(endpoint: EndPoint, body: U) async throws -> (T, HTTPURLResponse) where T : Decodable, U : Encodable {
        try await APIClient.shared.postRequest(endpoint: endpoint, body: body)
    }
}
