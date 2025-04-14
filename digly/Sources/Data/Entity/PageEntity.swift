//
//  PageEntity.swift
//  Digly
//
//  Created by 윤동주 on 4/6/25.
//

import Foundation

struct PageEntity: Codable {
    let page: Int
    let size: Int
    let totalElements: Int
    let totalPages: Int
}
