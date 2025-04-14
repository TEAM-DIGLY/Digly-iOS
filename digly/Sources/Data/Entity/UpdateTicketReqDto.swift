//
//  UpdateTicketReqDto.swift
//  Digly
//
//  Created by 윤동주 on 4/6/25.
//

import Foundation

struct UpdateTicketReqDto: Codable {
    let name: String
    let performanceTime: String
    let place: String
    let seatRow: String
    let seatNumber: String
    let price: Int
}
