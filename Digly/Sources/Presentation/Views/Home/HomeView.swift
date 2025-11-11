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
        .overlay {
            if viewModel.showDdayAlert, let ticket = viewModel.ddayTicket {
                DdayAlertPopup(
                    isPresented: $viewModel.showDdayAlert,
                    ticket: ticket,
                    onEmotionButtonTap: {
                        viewModel.showDdayAlert = false
                        viewModel.showEmotionBottomSheet = true
                    }
                )
            }
        }
        .overlay {
            if viewModel.showEmotionCompletedPopup, let ticket = viewModel.ddayTicket {
                EmotionCompletedPopup(
                    isPresented: $viewModel.showEmotionCompletedPopup,
                    ticket: ticket,
                    selectedEmotions: viewModel.selectedEmotions,
                    onViewRecord: {
                        viewModel.navigateToEmotionRecord()
                    }
                )
            }
        }
        .sheet(isPresented: $viewModel.showEmotionBottomSheet) {
            if let ddayTicket = viewModel.ddayTicket {
                EmotionSelectionBottomSheet(
                    ticketId: ddayTicket.id,
                    currentEmotions: ddayTicket.emotions,
                    onEmotionsUpdated: { emotions in
                        viewModel.handleEmotionComplete(emotions: emotions)
                    }
                )
                .presentationDetents([.height(604)])
                .presentationDragIndicator(.hidden)
            }
        }
        .onAppear {
            // Check for D-day tickets when view appears
            viewModel.checkForDdayTickets()
        }
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
                            .foregroundStyle(.neutral600)
                        
                        HStack(spacing: 0) {
                            Text("\(viewModel.noteCount)")
                                .fontStyle(.headline2)
                                .foregroundStyle(.neutral800)
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
        .background(.neutral100, in: UnevenRoundedRectangle(topLeadingRadius: 64))
    }
    
    private var headerSection: some View {
        HStack (spacing: 4) {
            Text("\(authManager.nickname)의")
                .fontStyle(.headline1)
                .foregroundStyle(.neutral900)
            
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
                            .foregroundStyle(.neutral800)
                            .padding(.vertical, 16)
                            .frame(maxWidth: .infinity)
                            .background(.common100, in: RoundedRectangle(cornerRadius: 16)
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(.neutral200, lineWidth: 1.5)
                            )
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
                }
                .frame(width: 300, height: 300)
            } else {
                TicketScrollView(
                    focusedIndex: $viewModel.focusedTicketIndex,
                    onIndexChanged: { index in
                        viewModel.updateFocusedTicket(index: index)
                    },
                    tickets:viewModel.tickets
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
                .foregroundStyle(.neutral400)
                .padding(24)
                .background(.neutral150, in: RoundedRectangle(cornerRadius: 24))
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
                        .foregroundStyle(.opacityCool600)
                        .padding(.bottom, 2)
                    
                    Text(ticket.time.toTimeString())
                        .fontStyle(.smallLine)
                        .foregroundStyle(.opacityCool600)
                        .padding(.bottom, 8)
                    
                    Text(ticket.place)
                        .fontStyle(.smallLine)
                        .foregroundStyle(.opacityCool600)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    HStack(spacing: 8) {
                        ForEach(Array(ticket.emotions.prefix(2).enumerated()), id: \.offset) { index, emotion in
                            if index < ticket.emotions.count {
                                tagView(text: "#\(emotion)", color: emotion.color)
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

