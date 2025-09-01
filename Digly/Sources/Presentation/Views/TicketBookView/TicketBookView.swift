import SwiftUI

struct TicketBookView: View {
    @StateObject private var viewModel = TicketBookViewModel()
    @EnvironmentObject private var router: TicketBookRouter
    
    // MARK: - Body
    var body: some View {
        DGScreen(horizontalPadding: 0) {
            ZStack {
                Color.black.edgesIgnoringSafeArea(.all)
                
                ScrollView {
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
        .onAppear {
            viewModel.setRouter(router)
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
                viewModel.addTicketAction()
            }) {
                VStack(spacing: 8) {
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
                ForEach(viewModel.tickets) { ticket in
                    TicketCardView(
                        title: ticket.title,
                        date: ticket.date,
                        location: ticket.location,
                        ticketNumber: ticket.number,
                        primaryColor: ticket.primaryColor,
                        secondaryColor: ticket.secondaryColor
                    )
                    .onTapGesture {
                        navigateToTicketDetail(ticketId: ticket.id.uuidString)
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
            
            Text("\(viewModel.totalTickets)")
                .fontStyle(.heading2)
                .foregroundStyle(.opacityWhite45)
            
            Spacer()
            
            Image("filter")
                .onTapGesture {
                    viewModel.filterAction()
                }
            
            Image("search")
                .onTapGesture {
                    viewModel.searchAction()
                }
        }
    }
    
    private var ticketGridView: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(), spacing: 20),
            GridItem(.flexible(), spacing: 20)
        ], spacing: 20) {
            ForEach(viewModel.tickets) { ticket in
                TicketCardView(
                    title: ticket.title,
                    date: ticket.date,
                    location: ticket.location,
                    ticketNumber: ticket.number,
                    cardType: .small,
                    primaryColor: ticket.primaryColor,
                    secondaryColor: ticket.secondaryColor
                )
                .onTapGesture {
                    navigateToTicketDetail(ticketId: ticket.id.uuidString)
                }
            }
        }
    }
    
    // MARK: - Navigation
    private func navigateToTicketDetail(ticketId: String) {
        router.path.append(TicketBookRoute.ticketDetail(ticketId))
    }
}

// MARK: - Preview
struct TicketBookView_Previews: PreviewProvider {
    static var previews: some View {
        TicketBookView()
            .environmentObject(TicketBookRouter())
    }
}
