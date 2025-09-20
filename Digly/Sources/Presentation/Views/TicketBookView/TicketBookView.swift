import SwiftUI

struct TicketBookView: View {
    @StateObject private var viewModel = TicketBookViewModel()
    @EnvironmentObject private var router: TicketBookRouter
    
    @State private var showSortBottomSheet = false
    
    var body: some View {
        DGScreen(horizontalPadding: 0, backgroundColor: .common0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    headerView
                    upperTicketList
                    subHeader
                    ticketGridView
                }
                .padding(.horizontal, 16)
            }
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
        .padding(.top, 16)
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
                            title: ticket.name,
                            date: ticket.time,
                            location: ticket.place,
                            ticketNumber: ticket.seatNumber,
                            cardType: .large,
                            colors: ticket.color
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
                    showSortBottomSheet = true
                }
            
            Image("search")
        }
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
                        title: ticket.name,
                        date: ticket.time,
                        location: ticket.place,
                        ticketNumber: ticket.seatNumber,
                        cardType: .small,
                        colors: ticket.color
                    )
                }
            }
        }
        .sheet(isPresented: $showSortBottomSheet) {
            SortBottomSheet(
                startedDate: $viewModel.startedDate,
                endDate: $viewModel.endDate
            )
        }
    }
}

// MARK: - Preview
#Preview {
    TicketBookView()
        .environmentObject(TicketBookRouter())
}
