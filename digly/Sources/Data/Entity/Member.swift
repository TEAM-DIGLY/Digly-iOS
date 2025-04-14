//
//  Member.swift
//  Digly
//
//  Created by 윤동주 on 4/6/25.
//

import Foundation

struct Member: Codable {
    let id: Int
    let name: String
    let platformId: String
    let platformType: PlatformType
    let memberType: MemberType
}

enum PlatformType: String, Codable {
    case kakao = "KAKAO"
    case apple = "APPLE"
    case withdraw = "WITHDRAW"
}

enum MemberType: String, Codable {
    case collection = "COLLECTION"
    case analyze = "ANALYZE"
    case communication = "COMMUNICATION"
}
