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

struct BottomTabView: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(TabItem.allCases, id: \.rawValue) { tab in
                TabItemView(tab: tab, isSelected: selectedTab == tab.rawValue){
                    withAnimation(.mediumSpring) {
                        selectedTab = tab.rawValue
                    }
                }
            }
            .padding(8)
        }
        .background(.common100, in: RoundedRectangle(cornerRadius: 27))
        .shadow(color: .common0.opacity(0.1), radius: 7, x: 0, y: 0)
        .padding(.horizontal, 24)
        .background(.clear)
    }
}

struct TabItemView: View {
    let tab: TabItem
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 0) {
                Image(tab.iconName)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(.neutral35)
                    .frame(width: 30, height: 30)
                
                Text(tab.title)
                    .fontStyle(.caption2)
                    .foregroundStyle(isSelected ? .neutral25 : .neutral25.opacity(0.4))
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 8)
            .background(isSelected ? .neutral85 : Color.clear, in: RoundedRectangle(cornerRadius: 22))
        }
    }
}
