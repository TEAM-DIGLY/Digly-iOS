//
//  Pageable.swift
//  Digly
//
//  Created by 윤동주 on 4/6/25.
//

import Foundation

struct Pageable: Codable {
    let page: Int
    let size: Int
    let sort: [String]
}
