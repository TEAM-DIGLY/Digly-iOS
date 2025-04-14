//
//  NoteHttpResponse.swift
//  Digly
//
//  Created by 윤동주 on 4/6/25.
//

import Foundation

struct NoteHttpResponse: Codable {
    let id: Int
    let title: String
    let content: String
}
