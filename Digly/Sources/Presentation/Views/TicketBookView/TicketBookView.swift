import SwiftUI

struct TicketBookView: View {
    @StateObject private var viewModel = TicketBookViewModel()
    @EnvironmentObject private var router: TicketBookRouter
    
    @State private var showSortBottomSheet = false
    @State private var showFilterBottomSheet = false
    
    var body: some View {
        DGScreen(horizontalPadding: 0, backgroundColor: .common0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    headerView
                    upperTicketList
                    Spacer().frame(height: 24)
                    subHeader
                    ticketGridView
                    Spacer().frame(height: 120)
                }
            }
        }
        .sheet(isPresented: $showFilterBottomSheet) {
            FilterBottomSheet(
                startedDate: $viewModel.startedDate,
                endDate: $viewModel.endDate
            )
            .presentationDetents([.height(480)])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(24)
            .background(.bottomSheetBackground)
            .presentationBackground(.bottomSheetBackground)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 4) {
                Text("\(viewModel.username)'s\nticket book")
                    .fontStyle(.title2)
                    .foregroundStyle(.common100)
            }
            
            Spacer()
            
            Button(action: {
                router.path.append(TicketFlowRoute.addTicket)
            }) {
                HStack(spacing: 8) {
                    Image("plus")
                        .resizable()
                        .frame(width: 16, height: 16)
                    
                    Text("티켓 추가")
                        .fontStyle(.label2)
                }
                .foregroundStyle(.common100)
                .padding(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(.opacityWhite75, lineWidth: 1)
                )
            }
        }
        .padding(16)
    }
    
    // MARK: - Featured Tickets View
    private var upperTicketList: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 16) {
                ForEach(viewModel.bigTickets) { ticket in
                    Button(action: {
                        router.push(to: .ticketDetail(ticket.id))
                    }) {
                        TicketCardView(
                            ticket: ticket,
                            cardType: .large
                        )
                    }
                }
            }
        }
    }
    
    private var subHeader: some View {
        HStack(spacing: 12) {
            Text("전체 티켓")
                .fontStyle(.heading2)
                .foregroundStyle(.white)
            
            Text("\(viewModel.totalCnt)")
                .fontStyle(.heading2)
                .foregroundStyle(.opacityWhite45)

            Spacer()
            
            Image("filter")
                .onTapGesture {
                    showFilterBottomSheet = true
                }
            
            Image("search")
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
    
    private var ticketGridView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 20),
            GridItem(.flexible(), spacing: 20)
        ], spacing: 20) {
            ForEach(viewModel.tickets) { ticket in
                Button(action: {
                    router.push(to: .ticketDetail(ticket.id))
                }) {
                    TicketCardView(
                        ticket: ticket,
                        cardType: .small
                    )
                }
            }
        }
    }
}

// MARK: - Preview
#Preview {
    TicketBookView()
        .environmentObject(TicketBookRouter())
}
