import SwiftUI

enum TicketCardType {
    case large
    case small
}

struct TicketCardView: View {
    var title: String
    var date: String
    var location: String
    var ticketNumber: Int
    var cardType: TicketCardType = .large
    var primaryColor: Color
    var secondaryColor: Color
    
    private var isLarge: Bool {
        cardType == .large
    }
    
    private var shapeOffsets: [CGFloat] {
        switch cardType {
        // upperXOffset, upperYOffset, bottomXOffset, bottomYOffset
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
            return [150, 180]
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
                upperGradientColors: [
                    primaryColor
                        .opacity(0.2),
                    primaryColor
                        .opacity(0.02)
                ],
                bottomGradientColors: [
                    secondaryColor
                        .opacity(0.2)
                    , secondaryColor
                        .opacity(0.1)
                ],
                offsets: shapeOffsets
            )
            
            ticketInfo
                .padding(.horizontal, isLarge ? 14 : 12)
                .padding(.vertical, 20)
                .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: cardType != .large ? .infinity : shapeSize[0], maxHeight: shapeSize[1])
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
    
    private var ticketInfo: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !isLarge {
                Text(date)
                    .font(.caption1)
                    .foregroundStyle(.opacityWhite25)
                    .padding(.bottom, 8)
            }
            
            HStack(alignment: .top){
                Text(title)
                    .fontStyle(isLarge ? .body1 : .body2)
                    .foregroundStyle(.white)
                    .lineLimit(2)
                
                Spacer()
                
                if isLarge {
                    Image("chevron_right")
                        .renderingMode(.template)
                        .foregroundStyle(.opacityWhite25)
                }
            }
            .padding(.bottom, 24)
            
            if isLarge {
                VStack(alignment: .leading, spacing: 8) {
                    Text("#\(ticketNumber)번째 관람")
                        .fontStyle(.caption1)
                        .foregroundStyle(.opacityWhite5)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(.opacityWhite75, lineWidth: 1)
                        )
                    
                    Text("\(date) • \(location)")
                        .fontStyle(.caption1)
                        .foregroundStyle(.opacityWhite15)
                        .lineLimit(1)
                }
            }
        }
    }
}

// MARK: - Preview
struct TicketCardView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            // 대형 카드
            TicketCardView(
                title: "ALADDIN\nThe Musical",
                date: "2024.01.19",
                location: "샤롯데씨어터",
                ticketNumber: 1,
                cardType: .large,
                primaryColor: .green,
                secondaryColor: .orange
            )
            
            // 소형 카드 (좌/우 배치)
            HStack(spacing: 12) {
                // 좌측 배치 카드
                TicketCardView(
                    title: "캣츠 내한공연\n50주년",
                    date: "2025.03.12",
                    location: "예술의전당",
                    ticketNumber: 2,
                    cardType: .small,
                    primaryColor: .purple,
                    secondaryColor: .yellow
                )
                
                // 우측 배치 카드
                TicketCardView(
                    title: "웃는남자",
                    date: "2024.12.25",
                    location: "블루스퀘어",
                    ticketNumber: 3,
                    cardType: .small,
                    primaryColor: .blue,
                    secondaryColor: .purple
                )
            }
        }
        .padding()
        .background(.black)
    }
} 
