import SwiftUI

enum TicketCardType {
    case large
    case small
}

struct TicketCardView: View {
    var title: String
    var date: Date
    var location: String
    var ticketNumber: String?
    var cardType: TicketCardType
    var colors: [String] = []
    
    private var isLarge: Bool {
        cardType == .large
    }
    
    private var shapeOffsets: [CGFloat] {
        switch cardType {
        case .large:
            return [-40, -40, -40, 56]
        case .small:
            return [-20, -20, -20, 20]
        }
    }
    
    private var shapeSize: [CGFloat] {
        switch cardType {
        case .large:
            return [200, 280]
        default:
            return [153, 182]
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
        ZStack {
            DiglyShape(
                upperGradientColors: gradientColors.upper,
                bottomGradientColors: gradientColors.bottom,
                offsets: shapeOffsets
            )
            
            ticketInfo
                .padding(.horizontal, isLarge ? 14 : 12)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(width: shapeSize[0], height: shapeSize[1])
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: cornerSize[0],
                bottomLeadingRadius: cornerSize[0],
                bottomTrailingRadius: cornerSize[1],
                topTrailingRadius: cornerSize[0]
            )
        )
        .shadow(color: .common100.opacity(0.2), radius: 20)
    }

    // MARK: - Gradient Colors Logic
    private var gradientColors: (upper: [Color], bottom: [Color]) {
        if !colors.isEmpty {
            let mapped = colors.map { Color(hex: $0) }
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
            [Color.neutral15.opacity(0.2), Color.neutral15.opacity(0.02)],
            [Color.neutral55.opacity(0.2), Color.neutral55.opacity(0.1)]
        )
    }
    
    private var ticketInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            if isLarge {
                HStack(alignment: .top){
                    Text(title)
                        .fontStyle(.body1)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Image("chevron_right")
                        .renderingMode(.template)
                        .foregroundStyle(.opacityWhite25)
                }
                .padding(.bottom, 48)
                
                Text("\(date.toInquiryDateString()) • \(location)")
                    .fontStyle(.caption1)
                    .foregroundStyle(.opacityWhite15)
                    .lineLimit(1)
            } else {
                Text(date.toInquiryDateString())
                    .font(.caption1)
                    .foregroundStyle(.opacityWhite25)
                    .padding(.bottom, 8)
                
                Text(title)
                    .fontStyle(.body2)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal, 16)
    }
}
