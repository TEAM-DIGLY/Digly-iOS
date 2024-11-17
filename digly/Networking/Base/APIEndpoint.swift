//
//  APIEndpoint.swift
//  tyte
//
//  Created by 김 형석 on 9/9/24.
//

import Foundation

enum APIEndpoint {
    case login
    case signUp
    //    case validateToken // Token
    case socialLogin(String) // Provider
    case deleteAccount(String) // username
    case checkUsername // username
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .signUp:
            return "/auth/register"
        case .deleteAccount(let username):
            return "/auth/\(username)"
        case .socialLogin(let provider):
            return "/auth/\(provider)"
        case .checkUsername:
            return "/auth/check-username"
        }
    }
}
