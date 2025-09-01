import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: HomeRouter
    
    @StateObject var viewModel = HomeViewModel()
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        DGScreen(horizontalPadding: 0, isAlignCenter: true, isLoading: viewModel.isLoading) {
            headerSection
            mainSection
            
            Spacer()
            
            notesSection
        }
        .edgesIgnoringSafeArea(.bottom)
    }
        
    private var notesSection: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Image(authManager.avatarImageName)
                    .padding(.bottom, authManager.paddingBottom)
                
                Button(action: {}) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("내가 수집한 티켓")
                            .fontStyle(.label1)
                            .foregroundStyle(.neutral35)
                        
                        HStack(spacing: 0) {
                            Text("\(viewModel.noteCount)")
                                .fontStyle(.headline2)
                                .foregroundStyle(.neutral15)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Image("chevron_right")
                        }
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 12)
                    .padding(.leading, 40)
                }
                .padding(.trailing, 8)
                .background(.common100, in: UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius:24,
                    topTrailingRadius: 24)
                )
            }
            
            stackSection
                .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 64)
        .frame(height: 330)
        .background(.neutral85, in: UnevenRoundedRectangle(topLeadingRadius: 64))
    }
    
    private var headerSection: some View {
        HStack (spacing: 4) {
            Text("\(authManager.nickname)의")
                .fontStyle(.headline1)
                .foregroundStyle(.neutral5)
            
            Image(authManager.logoImageName)
                .resizable()
                .frame(width: 48,height:23)
            
            Spacer()
            
            Button(action:{
                router.push(to: .alarmList)
            }) {
                Image("alert")
            }
            
            Button(action:{
                router.push(to: .myPage)
            }) {
                Image(authManager.profileImageName)
            }
        }
        .frame(height:80)
        .padding(.horizontal, 36)
    }
    
    @ViewBuilder
    private var mainSection: some View {
        Group {
            if viewModel.tickets.isEmpty {
                ZStack(alignment: .bottom) {
                    Image(authManager.baseImageName)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    
                    Button(action: {
                        router.push(to: .addTicket)
                    }) {
                        Text("관람 예정 티켓 추가하기")
                            .fontStyle(.headline1)
                            .foregroundStyle(.neutral15)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(.common100, in: RoundedRectangle(cornerRadius: 16)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.neutral75, lineWidth: 1.5)
                            )
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
                .frame(width: 300, height: 300)
            } else {
                TicketScrollView(
                    tickets: viewModel.tickets,
                    focusedIndex: $viewModel.focusedTicketIndex,
                    onIndexChanged: { index in
                        viewModel.updateFocusedTicket(index: index)
                    }
                )
            }
        }
        .padding(.horizontal, 45)
        .padding(.bottom, 16)
    }
    
    @ViewBuilder
    private var stackSection: some View {
        if viewModel.tickets.isEmpty {
            Text("아직 등록한\n티켓이 없어요")
                .fontStyle(.body1)
                .multilineTextAlignment(.center)
                .foregroundStyle(.neutral55)
                .padding(24)
                .background(.neutral84, in: RoundedRectangle(cornerRadius: 24))
        } else if viewModel.tickets.count == 1 {
            ticketCard(isMain: true, ticketIndex: 0)
        } else {
            ZStack {
                ticketCard(isMain: false, ticketIndex: 1)
                    .offset(x: 10, y: 15)
                    .scaleEffect(0.95)
                
                ticketCard(isMain: true, ticketIndex: 0)
            }
        }
    }
    
    @ViewBuilder
    private func ticketCard(isMain: Bool, ticketIndex: Int) -> some View {
        if let ticket = viewModel.tickets.indices.contains(ticketIndex) ? viewModel.tickets[ticketIndex] : nil {
            VStack(spacing: 12) {
                VStack(spacing: 8) {
                    Text(ticket.name)
                        .fontStyle(.headline1)
                        .foregroundStyle(.common100)
                        .lineLimit(1)
                    
                    VStack(spacing: 2) {
                        Text(ticket.performanceTime.toTicketDateString())
                            .fontStyle(.label1)
                            .foregroundStyle(.common100.opacity(0.8))
                        Text(ticket.performanceTime.toTimeString())
                            .fontStyle(.label1)
                            .foregroundStyle(.common100.opacity(0.8))
                    }
                    
                    Text(ticket.place)
                        .fontStyle(.caption2)
                        .foregroundStyle(.common100.opacity(0.7))
                        .lineLimit(1)
                }
                .padding(.horizontal, 14)
                .padding(.top, 19)
                .padding(.bottom, 8)
                
                Divider()
                    .background(.common100.opacity(0.3))
                    .padding(.horizontal, 14)
                
                HStack(spacing: 8) {
                    ForEach(Array(ticket.feeling.prefix(2).enumerated()), id: \.offset) { index, feeling in
                        tagView(text: "#\(feeling)", color: getTagColor(index: index))
                    }
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
            .frame(width: isMain ? 146 : 140, height: isMain ? 197 : 190)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: getGradientColors(for: ticket)),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        }
    }
    
    
    private func getTagColor(index: Int) -> Color {
        let colors: [Color] = [.green, .orange, .blue, .purple, .red]
        return colors[index % colors.count]
    }
    
    private func getGradientColors(for ticket: Ticket) -> [Color] {
        // Convert color strings to actual colors
        let colorMapping: [String: Color] = [
            "blue": .blue,
            "purple": .purple,
            "green": .green,
            "orange": .orange,
            "red": .red,
            "yellow": .yellow,
            "pink": .pink
        ]
        
        let colors = ticket.color.compactMap { colorString in
            colorMapping[colorString.lowercased()]
        }
        
        if colors.count >= 2 {
            return [colors[0].opacity(0.8), colors[1].opacity(0.6)]
        } else if colors.count == 1 {
            return [colors[0].opacity(0.8), colors[0].opacity(0.6)]
        } else {
            return [.blue.opacity(0.8), .purple.opacity(0.6)]
        }
    }
    
    private func tagView(text: String, color: Color) -> some View {
        Text(text)
            .fontStyle(.caption2)
            .foregroundStyle(.neutral15)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 11))
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeRouter())
}

