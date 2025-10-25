import SwiftUI

enum TicketCardType {
    case large
    case small
    case note_small
}

struct TicketCardView: View {
    let ticket: Ticket
    let cardType: TicketCardType
    
    private var shapeOffsets: [CGFloat] {
        switch cardType {
        case .large:
            return [-40, -40, -40, 56]
        default:
            return [0, -20, -5, 20]
        }
    }
    
    private var patterns: [CGFloat] {
        switch cardType {
        case .large:
            [0, 1.2, 1.6, 2.0, 2.6, 3.0, 3.2]
        default:
            [1.6, 2.1, 2.5, 2.8, 3.0, 2.9]
        }
    }
    
    private var cornerSize: [CGFloat] {
        switch cardType {
        case .large:
            return [24, 100]
        default:
            return [16,78]
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            DiglyShape(
                upperGradientColors: gradientColors.upper,
                bottomGradientColors: gradientColors.bottom,
                patterns: patterns,
                offsets: shapeOffsets
            )
            
            ticketInfo
                .padding(.vertical, 20)
                .padding(.horizontal, 16)
        }
        .frame(maxWidth: cardType == .large ? 200 : .infinity)
        .frame(height: cardType == .large ? 200 : 185)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: cornerSize[0],
                bottomLeadingRadius: cornerSize[0],
                bottomTrailingRadius: cornerSize[1],
                topTrailingRadius: cornerSize[0]
            )
        )
        .shadow(color: .common100.opacity(0.2), radius: 10)
        .padding(10)
    }

    // MARK: - Gradient Colors Logic
    private var gradientColors: (upper: [Color], bottom: [Color]) {
        if !ticket.color.isEmpty {
            let mapped = ticket.color.map { $0.color }
            if mapped.count == 1 {
                let c = mapped[0]
                return ([c.opacity(0.2), c.opacity(0.02)], [c.opacity(0.2), c.opacity(0.1)])
            }
            let upperBase = mapped.enumerated().compactMap { idx, c in idx % 2 == 0 ? c : nil }
            let bottomBase = mapped.enumerated().compactMap { idx, c in idx % 2 == 1 ? c : nil }
            let upper = upperBase.isEmpty ? [mapped.first!] : upperBase
            let bottom = bottomBase.isEmpty ? [mapped.last!] : bottomBase
            let upperGrad = upper.enumerated().map { i, c in c.opacity(i == 0 ? 0.2 : 0.08) }
            let bottomGrad = bottom.enumerated().map { i, c in c.opacity(i == 0 ? 0.2 : 0.1) }
            return (upperGrad, bottomGrad)
        }
        
        return (
            [.neutral800.opacity(0.2), .neutral800.opacity(0.02)],
            [.neutral400.opacity(0.2), .neutral400.opacity(0.1)]
        )
    }
    
    private var ticketInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            switch cardType {
            case .large:
                HStack(alignment: .top){
                    Text(ticket.name)
                        .fontStyle(.body1)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image("chevron_right")
                        .renderingMode(.template)
                        .foregroundStyle(.opacityWhite700)
                }
                .padding(.bottom, 24)
                
                Text("#\(ticket.count)번째 관람")
                    .foregroundStyle(.opacityWhite850)
                    .font(.caption1)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.opacityWhite200, lineWidth: 1)
                    )
                    .padding(.bottom, 8)
                
                Text("\(ticket.time.toInquiryDateString()) • \(ticket.place)")
                    .fontStyle(.caption1)
                    .foregroundStyle(.opacityWhite800)
                    .lineLimit(1)
            case .small:
                Text("#\(ticket.count)번째 관람")
                    .foregroundStyle(.opacityWhite850)
                    .font(.caption1)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.opacityWhite200, lineWidth: 1)
                    )
                    .padding(.bottom, 12)
                
                Text(ticket.name)
                    .fontStyle(.body2)
                    .foregroundStyle(.white)
                    .lineLimit(2)
            case .note_small:
                HStack(spacing: 4){
                    Text("관람일")
                    
                    Circle()
                        .fill(.neutral500)
                        .frame(width: 2, height: 2)
                    
                    Text(ticket.time.toInquiryDateString())
                }
                .fontStyle(.caption1)
                .foregroundStyle(.neutral300)
                .padding(.bottom, 8)
                
                Text(ticket.name)
                    .fontStyle(.body2)
                    .foregroundStyle(.neutral300)
                    .lineLimit(2)
                
                Spacer()
                
                if let noteCnt = ticket.notes?.count {
                    HStack(spacing: 4) {
                        Image("digging_note")
                            .renderingMode(.template)
                            .resizable()
                            .foregroundStyle(.neutral400)
                            .frame(width: 12, height: 12)
                        
                        
                        Text("\(noteCnt)개의 노트")
                            .fontStyle(.caption1)
                            .foregroundStyle(.opacityWhite850)
                        
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(.opacityWhite100, lineWidth: 1)
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
