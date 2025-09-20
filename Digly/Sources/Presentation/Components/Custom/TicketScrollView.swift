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
            switch (daysUntil) {
            case 0:
                Image("DDayBox")
                    .aspectRatio(contentMode: .fit)
                
            case 1...3:
                Image(authManager.liveBaseImageName)
                    .aspectRatio(contentMode: .fit)
                
            default:
                RoundedRectangle(cornerRadius: 28)
                    .fill(.neutral95)
                    .stroke(.neutral75, lineWidth: 1.5)
                    .padding(1)
            }
            
            VStack(alignment: 0 <= daysUntil && daysUntil < 4 ? .center : .leading, spacing: 0) {
                Spacer()
                
                Text(DDayString(daysUntil))
                    .fontStyle(.title1)
                    .foregroundStyle(DDayForegroundColor(daysUntil))
                    .padding(.bottom, 24)
                    .padding(.horizontal, 8)
                
                Text(ticket.name)
                    .fontStyle(.body2)
                    .foregroundStyle(foregroundTicketNameColor(daysUntil))
                    .padding(.bottom, 8)
                    .padding(.horizontal, 8)
                
                Text(ticket.place)
                    .fontStyle(.body2)
                    .foregroundStyle(foregroundTicketNameColor(daysUntil))
                    .padding(.horizontal, 8)
                
                Spacer()
                
                Button(action: {
                    // Navigate to ticket detail
                }) {
                    Text(ticket.name)
                        .fontStyle(.heading2)
                        .foregroundStyle(foregroundColor(daysUntil))
                }
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity)
                .background(backgroundColor(daysUntil), in: RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .frame(width: 264, height: 280)
        .scaleEffect(isFocused ? 1.0 : 0.9)
        .animation(.spring, value: isFocused)
    }
    
    private func DDayString(_ days: Int) -> String {
        switch days {
        case 0:
            return "D-DAY"
        default:
            return "D\(days < 0 ? "+" : "")\(days * -1)"
        }
    }
    
    private func DDayForegroundColor(_ days: Int) -> Color {
        switch days {
        case 0:
            return .neutral5
        case 1...3:
            return .common100
        default:
            return authManager.digly.color
        }
    }
    
    private func daysUntilPerformance(for ticket: Ticket) -> Int {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let performanceDay = calendar.startOfDay(for: ticket.time)
        
        let components = calendar.dateComponents([.day], from: today, to: performanceDay)
        return components.day ?? 0
    }
    
    private func foregroundColor(_ days: Int) -> Color {
        switch days {
        case 0...3:
            return .common100
        default:
            return .neutral5
        }
    }
    
    private func backgroundColor(_ days: Int) -> Color {
        switch days {
        case 0...3:
            return .opacityCool25
        default:
            return authManager.digly.lightColor
        }
    }
    
    private func foregroundTicketNameColor(_ days: Int) -> Color {
        switch days {
        case 0:
            return .text0
        case 1...3:
            return authManager.digly.lightColor
        default:
            return .neutral55
        }
    }
    
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
