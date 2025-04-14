//
//  LoginError.swift
//  Digly
//
//  Created by 윤동주 on 3/9/25.
//

import Foundation

enum LoginError: LocalizedError {
    case kakaoAccessTokenTypeError
    case appleAccessTokenTypeError
    case appleAccessTokenError
    case appleAccessTokenExpired
    case appleAccessTokenClaimError
    case appleLoginPuplicKeyError
    
    var errorDescription: String? {
        switch self {
        case .kakaoAccessTokenTypeError: 
            return "알수 없는 에러입니다."
        case .appleAccessTokenTypeError: 
            return "애플 아이덴터티 토큰의 형식이 올바르지 않습니다."
        case .appleAccessTokenError: 
            return "애플 아이덴터티 토큰의 값이 올바르지 않습니다."
        case .appleAccessTokenExpired:
            return "애플 아이덴터티 토큰의 유효 기간이 만료되었습니다."
        case .appleAccessTokenClaimError:
            return "애플 아이덴터티 토큰의 클레임 값이 올바르지 않습니다."
        case .appleLoginPuplicKeyError:
            return "애플 로그인 중 퍼블릭 키 생성에 문제가 발생했습니다."
        }
    }
}
