//
//  SignUpReqDto.swift
//  Digly
//
//  Created by 윤동주 on 4/6/25.
//

import Foundation

struct SignUpReqDto: Codable {
    let name: String
    let memberType: MemberType
}
