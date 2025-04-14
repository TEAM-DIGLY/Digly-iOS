//
//  TicketHttpResponse.swift
//  Digly
//
//  Created by 윤동주 on 4/6/25.
//

import Foundation

struct TicketHttpResponse: Codable {
    let id: Int
    let name: String
    let performanceTime: String
    let place: String
    let count: Int
    let seatNumber: String
    let price: Int
}
