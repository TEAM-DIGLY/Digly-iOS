//
//  AuthRepository.swift
//  Digly
//
//  Created by 윤동주 on 4/6/25.
//

import Foundation

struct AuthRepository {
    private var networkService = DGNetworkService()
    
    func authLogin(with dto: SignInReqDto) async throws -> (SignInResDto, HTTPURLResponse) {
        let endpoint = EndPoint(
            path: "/api/v1/auth/login",
            method: .post,
            headers: [
                "Content-Type": "application/json"
            ]
        )
        return try await networkService.post(
            endpoint: endpoint, body: dto
        )
    }
}
