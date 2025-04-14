//
//  CreateNoteReqDto.swift
//  Digly
//
//  Created by 윤동주 on 4/6/25.
//

import Foundation

struct CreateNoteReqDto: Codable {
    let ticketId: Int
    let title: String
    let content: String
}
