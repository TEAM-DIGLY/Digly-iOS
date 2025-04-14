//
//  TicketsHttpResponse.swift
//  Digly
//
//  Created by 윤동주 on 4/6/25.
//

import Foundation

struct TicketsHttpResponse: Codable {
    let tickets: [TicketHttpResponse]
    let pageInfo: PageEntity
}
