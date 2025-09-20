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
                    bottomTrailingRadius: 24,
                    topTrailingRadius: 24)
                )
            }
            
            stackSection
                .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 120)
        .frame(height: 360)
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
        VStack(alignment: .center) {
            if viewModel.tickets.isEmpty {
                ZStack(alignment: .bottom) {
                    Image(authManager.baseImageName)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    
                    Button(action: {
                        router.path.append(TicketFlowRoute.addTicket)
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
            ticketCard
        } else {
            ZStack {
                Image("ticket-base")
                    .rotationEffect(Angle(degrees: 4))
                ticketCard
            }
        }
    }
    
    @ViewBuilder
    private var ticketCard: some View {
        if let ticket = viewModel.tickets.first {
            ZStack {
                Image("ticket-base")
                
                VStack(alignment: .leading, spacing: 0) {
                    Text(ticket.name)
                        .fontStyle(.body2)
                        .foregroundStyle(.text0)
                        .lineLimit(1)
                        .padding(.bottom, 12)
                    
                    Text(ticket.time.toTicketDateString())
                        .fontStyle(.smallLine)
                        .foregroundStyle(.opacityCool35)
                        .padding(.bottom, 2)
                    
                    Text(ticket.time.toTimeString())
                        .fontStyle(.smallLine)
                        .foregroundStyle(.opacityCool35)
                        .padding(.bottom, 8)
                    
                    Text(ticket.place)
                        .fontStyle(.smallLine)
                        .foregroundStyle(.opacityCool35)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        ForEach(Array(ticket.feeling.prefix(2).enumerated()), id: \.offset) { index, feeling in
                            if index < ticket.color.count {
                                tagView(text: "#\(feeling)", color: Color(hex: ticket.color[index]))
                            }
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 12)
                .padding(.top, 16)
                .padding(.bottom, 12)
            }
            .frame(width: 146, height: 197)
        }
    }
    
    private func tagView(text: String, color: Color) -> some View {
        Text(text)
            .fontStyle(.caption2)
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(color.opacity(0.1), in: RoundedRectangle(cornerRadius: 8))
    }
    
    private func getTagColor(index: Int) -> Color {
        let colors: [Color] = [.green, .orange, .blue, .purple, .red]
        return colors[index % colors.count]
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeRouter())
}

