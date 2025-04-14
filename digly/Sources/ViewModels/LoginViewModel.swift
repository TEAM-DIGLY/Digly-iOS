//
//  LoginViewModel.swift
//  Digly
//
//  Created by 윤동주 on 3/9/25.
//

import Foundation

class LoginViewModel {
    var socialLoginManager: SocialLoginManager = SocialLoginManager()
    var networkService: DGNetworkService = DGNetworkService()
    
    func login(platformType: PlatformType) async throws -> (LoginResultDTO, HTTPURLResponse) {
        switch platformType {
        case .kakao:
            guard let accesstoken = await socialLoginManager.getKakaoAccessToken() else {
                throw LoginError.kakaoAccessTokenTypeError
            }
            let endpoint = EndPoint(
                path: "/api/v1/auth/login",
                method: .post,
                headers: [
                    "Content-Type": "application/json",
                    "Authorization": "Bearer \(accesstoken)"
                ]
            )
            return try await networkService.post(
                endpoint: endpoint,
                body: ["platform": platformType.rawValue]
            )
        default:
            throw LoginError.kakaoAccessTokenTypeError
        }
    }
}
