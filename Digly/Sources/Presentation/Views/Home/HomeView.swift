import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: HomeRouter
    
    @StateObject var viewModel = HomeViewModel()
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        DGScreen(horizontalPadding: 0, isAlignCenter: true) {
            headerSection
            
            mainSection
            Divider()
                .padding(.horizontal, 64)
                .padding(.vertical, 16)
                .padding(.bottom, 16)
            
            HStack(alignment: .bottom) {
                VStack(spacing: 0) {
                    Image(authManager.avatarImageName)
                        .padding(.bottom, authManager.paddingBottom)
                    
                    VStack(alignment:.leading) {
                        Text("내가 작성한 노트")
                            .fontStyle(.label1)
                            .foregroundStyle(.neutral15)
                        
                        HStack {
                            Text("\(viewModel.noteCount)")
                                .fontStyle(.headline2)
                                .foregroundStyle(.neutral15)
                            Spacer()
                            
                            Image("chevron_right")
                                .foregroundStyle(.neutral45)
                        }
                    }
                    .frame(width: 120)
                    .padding(14)
                    .background(.opacityCool95)
                    .cornerRadius(24)
                }
                
                Spacer()
                
                stackSection
            }
            .padding(.horizontal, 32)
            .padding(.trailing, 64)
            .padding(.bottom, 24)
            
            Spacer()
        }
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
        Group{
            if viewModel.tickets.isEmpty {
                ZStack {
                    Image(authManager.baseImageName)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                    
                    VStack(spacing: 24) {
                        Spacer()
                        
                        Button(action: {
                            //                            router.push(to: .ticketList)
                        }) {
                            Text("예매한 티켓 추가하기")
                                .fontStyle(.heading2)
                                .foregroundStyle(.common0)
                                .frame(width: 240, height: 60)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(.neutral85)
                                        .opacity(0.8)
                                        .shadow(color: .common0.opacity(0.15), radius: 4)
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
    
    private var stackSection: some View {
        ZStack {
            ForEach(Array(viewModel.notes.prefix(3).enumerated()), id: \.element.id) { index, note in
                RoundedRectangle(cornerRadius: 24)
                    .fill(.neutral85)
                    .frame(width: 112, height: 112)
                    .foregroundColor(.clear)
                    .shadow(color: .common0.opacity(0.15), radius: 4)
                    .rotationEffect(.degrees(index == 0 ? 20 : index == 1 ? -20 : 0))
                    .offset(
                        x: index == 0 ? 12 : index == 1 ? -16 : 0,
                        y: index == 0 ? 0 : index == 1 ? 24 : 44
                    )
                    .overlay(
                        Text(note.title)
                            .fontStyle(.caption1)
                            .foregroundStyle(.neutral15)
                            .multilineTextAlignment(.center)
                            .padding(8)
                            .rotationEffect(.degrees(index == 0 ? 20 : index == 1 ? -20 : 0))
                    )
            }
            
            Image("plus")
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(.neutral85)
                        .frame(width: 130, height: 130)
                        .foregroundColor(.clear)
                        .shadow(color: .common0.opacity(0.15), radius: 4)
                )
                .onTapGesture {
                    print("add note for ticket: \(viewModel.focusedTicket?.name ?? "none")")
                }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(HomeRouter())
}

