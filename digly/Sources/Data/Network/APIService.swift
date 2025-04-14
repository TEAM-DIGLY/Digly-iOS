//
//  APIService.swift
//  Digly
//
//  Created by 윤동주 on 3/9/25.
//

import Foundation

protocol APIService {
    func get<T: Decodable>(endpoint: EndPoint) async throws -> T
    func post<T: Decodable, U: Encodable>(endpoint: EndPoint, body: U) async throws -> (T, HTTPURLResponse)
}
