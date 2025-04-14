//
//  SuccessResponseObject.swift
//  Digly
//
//  Created by 윤동주 on 4/6/25.
//

import Foundation

struct SuccessResponseObject: Codable {
    let status: Int
    let message: String
    let data: Data
}
