//
//  EndPoint.swift
//  Digly
//
//  Created by 윤동주 on 3/9/25.
//

import Foundation

struct EndPoint {
    var path: String
    var method: HTTPMethod
    var headers: [String: String]
    var queryItems: [URLQueryItem] = []
    
    var url: URL? {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "digly.shop"
        components.path = path
        components.queryItems = queryItems.isEmpty ? nil : queryItems
        components.percentEncodedQuery = components.percentEncodedQuery?
                    .replacingOccurrences(of: "+", with: "%2B")
        
        return components.url
    }
}
