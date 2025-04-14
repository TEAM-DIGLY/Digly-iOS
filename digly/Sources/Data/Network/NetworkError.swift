//
//  NetworkError.swift
//  Digly
//
//  Created by 윤동주 on 3/9/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidHttpStatusCode(code: Int)
    case decodeError
    case urlRequestFailed(description: String)
}
