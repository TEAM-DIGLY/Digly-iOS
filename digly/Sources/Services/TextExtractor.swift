//
//  TextExtractor.swift
//  Digly
//
//  Created by 윤동주 on 1/26/25.
//

import Foundation

struct TextExtractor {

    /// Melon 티켓 내의 정보 추출
    func extractTicketTextFromMelon(from text: String) -> [String] {
        var results = [String]()
        
        // 텍스트를 줄 단위로 나누기
        let lines = text.components(separatedBy: "\n")
        
        // 공연명: "[멜론티켓/예매결제완료]" 바로 다음 줄
        if let index = lines.firstIndex(where: { $0.contains("[멜론티켓/예매결제완료]") }), index + 1 < lines.count {
            results.append(lines[index + 1].trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
        // 공연장, 관람일시, 예매번호를 정규표현식으로 추출
        let patterns = [
            "공연장 : ([^\n]+)",        // 공연장
            "관람일시 : ([^\n]+)",      // 관람일시
            "예매번호 : (\\d+)"         // 예매번호
        ]
        
        for pattern in patterns {
            if let match = text.range(of: pattern, options: .regularExpression) {
                if let extracted = text[match].components(separatedBy: ": ").last {
                    results.append(extracted.trimmingCharacters(in: .whitespacesAndNewlines))
                }
            }
        }
        
        return results
    }

}
