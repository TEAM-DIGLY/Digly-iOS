import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: HomeRouter

    @StateObject var viewModel = HomeViewModel()
    @StateObject private var authManager = AuthManager.shared
    @StateObject private var popupManager = PopupManager.shared
    
    @State private var focusedIndex: Int = 0
    @AppStorage(UserDefaultKeys.nickname) private var nicknameUD: String = ""

    var displayNickname: String {
        nicknameUD.isEmpty ? authManager.nickname : nicknameUD
    }
    
    var body: some View {
        DGScreen(horizontalPadding: 0, isAlignCenter: true, isLoading: viewModel.isLoading) {
            headerSection
            ticketThumbnailContent
            Spacer()
            notesContent
        }
        .sheet(isPresented: $viewModel.isEmotionSheetPresent) {
            EmotionSelectionBottomSheet(
                currentEmotions: [],
                updateEmotion: { emotions in
                    viewModel.updateDdayTicketEmotion(emotions)
                }
            )
            .presentationDetents([.height(600)])
            .presentationDragIndicator(.hidden)
        }
        .overlay {
            if viewModel.isTutorialPresent {
                
            }
        }
        .onAppear {
            viewModel.fetchDdayTickets()
        }
        .onChange(of: viewModel.ddayTickets) { _, tickets in
            if !tickets.isEmpty {
                PopupManager.shared.show(.custom(
                    DdayAlertPopup(
                        tickets: viewModel.ddayTickets,
                        onEmotionButtonTap: { ticket in
                            viewModel.selectedDdayTicketId = ticket.id
                            viewModel.isEmotionSheetPresent = true
                        }
                    )
                ))
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isTutorialPresent)
    }

    private var notesContent: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(spacing: 0) {
                Image(authManager.avatarImageName)
                    .padding(.bottom, authManager.paddingBottom)
                
                Button(action: {
                    viewModel.navigateToTicketBook()
                }) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("내가 수집한 티켓")
                            .fontStyle(.label1)
                            .foregroundStyle(.neutral600)
                        
                        HStack(spacing: 0) {
                            Text("\(viewModel.tickets.count)")
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
            
            ticketStackSection
                .frame(maxWidth: .infinity)
        }
        .padding(.bottom, 120)
        .frame(height: 360)
        .background(.neutral100, in: UnevenRoundedRectangle(topLeadingRadius: 64))
    }
    
    private var headerSection: some View {
        HStack (spacing: 4) {
            Text("\(displayNickname)의")
                .fontStyle(.headline1)
                .foregroundStyle(.neutral900)
            
            Image(authManager.logoImageName)
                .resizable()
                .frame(width: 48,height:23)
            
            Spacer()
            
            Button(action:{ router.push(to: .alarmList)}) { Image("alert")}
            
            Button(action:{ router.push(to: .myPage)}) { Image(authManager.profileImageName)}
        }
        .frame(height:80)
        .padding(.horizontal, 36)
    }
    
    @ViewBuilder
    private var ticketThumbnailContent: some View {
        VStack(alignment: .center) {
            if viewModel.tickets.isEmpty {
                ticketThumbnailPlaceholder
            } else {
                ticketList
            }
        }
        .padding(.bottom, 16)
    }
    
    private var ticketThumbnailPlaceholder: some View {
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
    }
    
    private var ticketList: some View {
        GeometryReader { geometry in
            let itemWidth: CGFloat = 264
            
            ScrollViewReader { _ in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(Array(viewModel.tickets.enumerated()), id: \.element.id) { index, ticket in
                            ticketView(for: ticket, at: index, width: itemWidth)
                                .scrollTransition { content, phase in
                                    content.opacity(phase.isIdentity ? 1.0 : 0.8)
                                }
                                .id(index)
                        }
                    }
                    .scrollTargetLayout()
                    .padding(.horizontal, (geometry.size.width - itemWidth) / 2)
                }
                .scrollTargetBehavior(.viewAligned)
                .frame(height: 300)
                .scrollPosition(id: .init(get: {
                    focusedIndex
                }, set: { newPosition in
                    if let newIndex = newPosition, newIndex >= 0 {
                        focusedIndex = newIndex
                    }
                }))
            }
        }
        .frame(height: 300)
    }
    
    @ViewBuilder
    private var ticketStackSection: some View {
        if viewModel.tickets.isEmpty {
            Text("아직 등록한\n티켓이 없어요")
                .fontStyle(.body1)
                .multilineTextAlignment(.center)
                .foregroundStyle(.neutral400)
                .padding(24)
                .background(.neutral150, in: RoundedRectangle(cornerRadius: 24))
        } else if viewModel.tickets.count == 1 {
            smallTicketCard
        } else {
            ZStack {
                Image("ticket-base")
                    .rotationEffect(Angle(degrees: 4))
                smallTicketCard
            }
        }
    }
    
    @ViewBuilder
    private var smallTicketCard: some View {
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
                        ForEach(Array(ticket.emotions.prefix(2)), id: \.self) { emotion in
                            Text("#\(emotion.rawValue)")
                                .fontStyle(.caption2)
                                .foregroundStyle(emotion.color)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(emotion.color50.opacity(0.2), in: RoundedRectangle(cornerRadius: 8))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(.horizontal, 12)
                .padding(.top, 16)
                .padding(.bottom, 12)
            }
            .frame(width: 146, height: 197)
        }
    }
    
    private func ticketView(for ticket: Ticket, at index: Int, width: CGFloat) -> some View {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let performanceDay = calendar.startOfDay(for: ticket.time)
        
        let components = calendar.dateComponents([.day], from: today, to: performanceDay)
        
        let daysUntil = components.day ?? 0
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
                    .fill(.neutral50)
                    .stroke(.neutral200, lineWidth: 1.5)
                    .padding(1)
            }
            
            VStack(alignment: 0 <= daysUntil && daysUntil < 4 ? .center : .leading, spacing: 0) {
                Spacer()
                
                var ddayForegroundColor: Color {
                    switch daysUntil {
                    case 0:
                        return .neutral900
                    case 1...3:
                        return .common100
                    default:
                        return authManager.digly.color
                    }
                }
                
                var foregroundColor: Color {
                    switch daysUntil {
                    case 0...3:
                        return .common100
                    default:
                        return .neutral900
                    }
                }
                
                var backgroundColor: Color {
                    switch daysUntil {
                    case 0...3:
                        return .opacityCool700
                    default:
                        return authManager.digly.lightColor
                    }
                }
                
                var ticketNameColor: Color {
                    switch daysUntil {
                    case 0:
                        return .text0
                    case 1...3:
                        return authManager.digly.lightColor
                    default:
                        return .neutral400
                    }
                }
                
                Text(daysUntil == 0 ? "D-DAY" : "D\(daysUntil < 0 ? "+" : "")\(daysUntil * -1)")
                    .fontStyle(.title1)
                    .foregroundStyle(ddayForegroundColor)
                    .padding(.bottom, 24)
                    .padding(.horizontal, 8)
                
                Text(ticket.name)
                    .fontStyle(.body2)
                    .foregroundStyle(ticketNameColor)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 8)
                
                Text(ticket.place)
                    .fontStyle(.body2)
                    .foregroundStyle(ticketNameColor)
                    .padding(.horizontal, 8)
                
                Spacer()
                
                Button(action: {
                    router.push(to: .ticketDetail(ticket.id))
                }) {
                    Text(ticket.name)
                        .fontStyle(.heading2)
                        .foregroundStyle(foregroundColor)
                }
                .padding(16)
                .lineLimit(1)
                .frame(maxWidth: .infinity)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: 20))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 24)
        }
        .frame(width: width, height: 280)
        .scaleEffect(isFocused ? 1.0 : 0.9)
        .animation(.spring, value: isFocused)
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeRouter())
}
