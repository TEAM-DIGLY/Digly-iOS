import SwiftUI

enum TabItem: Int, CaseIterable {
    case home = 0
    case diggingNote = 1  
    case ticketBook = 2
    
    var title: String {
        switch self {
        case .home:
            return "home"
        case .diggingNote:
            return "digging note"
        case .ticketBook:
            return "ticket book"
        }
    }
    
    var iconName: String {
        switch self {
        case .home:
            return "home"
        case .diggingNote:
            return "digging_note"
        case .ticketBook:
            return "ticket_book"
        }
    }
}

private struct BottomTabAppearance {
    let background: Color
    let icon: Color
    let text: Color
    let selectionBackground: Color
    let shadowColor: Color
    
    static let light = BottomTabAppearance(
        background: .common100,
        icon: .neutral35,
        text: .neutral25,
        selectionBackground: .neutral85,
        shadowColor: .common0.opacity(0.08)
    )
    
    static let dark = BottomTabAppearance(
        background: .bgDark,
        icon: .neutral65,
        text: .neutral85,
        selectionBackground: .opacityWhite85,
        shadowColor: .common100.opacity(0.08)
    )
}

struct DGBottomTab: View {
    @Binding var selectedTab: Int
    
    private var appearance: BottomTabAppearance {
        if selectedTab == TabItem.home.rawValue {
            return .light
        } else {
            return .dark
        }
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                tabItem(tab)
            }
            .padding(8)
        }
        .background(appearance.background, in: RoundedRectangle(cornerRadius: 27))
        .shadow(color: appearance.shadowColor, radius: 12, x: 0, y: 0)
        .padding(.horizontal, 24)
        .background(.clear)
        
    }
    
    @ViewBuilder
    private func tabItem(_ tab: TabItem) -> some View {
        let isSelected = selectedTab == tab.rawValue
        
        Button(action: { selectedTab = tab.rawValue }) {
            VStack(spacing: 0) {
                Image(tab.iconName)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(appearance.icon.opacity(isSelected ? 1.0 : 0.4))
                    .frame(width: 30, height: 30)
                
                Text(tab.title)
                    .fontStyle(.caption2)
                    .foregroundStyle(appearance.text.opacity(isSelected ? 1.0 : 0.4))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(isSelected ? appearance.selectionBackground : .clear)
            )
        }
    }
}
