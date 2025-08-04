import SwiftUI

struct TicketScrollView: View {
    let tickets: [Ticket]
    @Binding var focusedIndex: Int
    let onIndexChanged: (Int) -> Void
    
    @StateObject private var authManager = AuthManager.shared
    @State private var scrollOffset: CGFloat = 0
    
    private let ticketWidth: CGFloat = 300
    private let spacing: CGFloat = 16
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    ForEach(Array(tickets.enumerated()), id: \.element.id) { index, ticket in
                        ticketView(for: ticket, at: index)
                            .frame(width: ticketWidth)
                    }
                }
                .padding(.horizontal, (geometry.size.width - ticketWidth) / 2)
                .background(
                    GeometryReader { scrollGeometry in
                        Color.clear
                            .preference(
                                key: ScrollOffsetPreferenceKey.self,
                                value: scrollGeometry.frame(in: .named("scroll")).minX
                            )
                    }
                )
            }
            .coordinateSpace(name: "scroll")
            .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                updateFocusedIndex(offset: value, viewWidth: geometry.size.width)
            }
        }
        .frame(height: 300)
    }
    
    private func updateFocusedIndex(offset: CGFloat, viewWidth: CGFloat) {
        let centerX = viewWidth / 2
        let adjustedOffset = abs(offset) + centerX - (viewWidth - ticketWidth) / 2
        let newIndex = Int(round(adjustedOffset / (ticketWidth + spacing)))
        let clampedIndex = max(0, min(tickets.count - 1, newIndex))
        
        if clampedIndex != focusedIndex {
            focusedIndex = clampedIndex
            onIndexChanged(clampedIndex)
        }
    }
    
    private func ticketView(for ticket: Ticket, at index: Int) -> some View {
        let daysUntil = daysUntilPerformance(for: ticket)
        let isFocused = index == focusedIndex
        
        return ZStack {
            // Background based on days until performance
            if daysUntil >= 4 {
                RoundedRectangle(cornerRadius: 28)
                    .fill(.neutral95)
                    .stroke(.neutral75, lineWidth: 1.5)
                    .frame(width: 300, height: 300)
            } else if daysUntil >= 1 {
                Image(authManager.liveBaseImageName)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
            } else {
                Image("DDayBox")
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300)
            }
            
            VStack(spacing: 24) {
                VStack(spacing: 2) {
                    Text(ticket.name)
                        .fontStyle(.body2)
                        .foregroundStyle(daysUntil >= 4 ? .neutral55 : 
                                        daysUntil >= 1 ? authManager.digly.lightColor : .opacityCool55)
                    
                    Text(daysUntil > 0 ? "D-\(String(format: "%02d", daysUntil))" : "D-DAY")
                        .fontStyle(.title1)
                        .foregroundStyle(daysUntil >= 4 ? authManager.digly.color :
                                        daysUntil >= 1 ? .common100 : .common0)
                }
                .padding(.top, 40)
                
                Button(action: {
                    // Navigate to ticket detail
                }) {
                    Text(ticket.name)
                        .fontStyle(.heading2)
                        .foregroundStyle(daysUntil >= 4 ? .common0 : .common100)
                        .frame(width: 240, height: 60)
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(backgroundColorForRemainingDays(daysUntil))
                                .opacity(opacityForRemainingDays(daysUntil))
                                .shadow(color: .common0.opacity(daysUntil >= 4 ? 0.15 : 0.0), radius: 4)
                        )
                }
                
                HStack(alignment: .bottom) {
                    Image("liveplay")
                    Spacer()
                    HStack(alignment: .center, spacing: 4) {
                        Image("secure")
                        Text("사용 가이드")
                            .fontStyle(.label1)
                            .foregroundStyle(.neutral15)
                        
                        Image("chevron_right")
                            .foregroundStyle(.neutral45)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 24)
            }
        }
        .frame(width: 300, height: 300)
        .scaleEffect(isFocused ? 1.0 : 0.9)
        .opacity(isFocused ? 1.0 : 0.7)
        .animation(.spring(response: 0.5, dampingFraction: 0.8), value: isFocused)
    }
    
    private func daysUntilPerformance(for ticket: Ticket) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let performanceDay = calendar.startOfDay(for: ticket.performanceTime)
        
        let components = calendar.dateComponents([.day], from: today, to: performanceDay)
        return components.day ?? 0
    }
    
    private func backgroundColorForRemainingDays(_ days: Int) -> Color {
        switch days {
        case 0...3:
            return .opacityCool65
        case 4:
            return authManager.digly.lightColor
        default:
            return .neutral85
        }
    }
    
    private func opacityForRemainingDays(_ days: Int) -> Double {
        switch days {
        case 0...3:
            return 0.25
        case 4:
            return 0.5
        default:
            return 0.8
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}