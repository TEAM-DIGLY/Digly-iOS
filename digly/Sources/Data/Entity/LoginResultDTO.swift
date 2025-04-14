//
//  LoginResultDTO.swift
//  Digly
//
//  Created by 윤동주 on 3/9/25.
//

import Foundation

struct LoginResultDTO: Codable {
    let id: Int
    let name: String
    let memberType: String
    let accessToken: String
    let refreshToken: String
    
    func toDomain() -> Token {
        return Token(
            accessToken: self.accessToken,
            refreshToken: self.refreshToken
        )
    }
}
