import SwiftUI

struct TicketDetailView: View {
    @StateObject private var viewModel: TicketDetailViewModel
    
    init(ticketId: String) {
        self._viewModel = StateObject(wrappedValue: TicketDetailViewModel(ticketId: ticketId))
    }
    
    private var ticketDetail: (title: String, userName: String, watchDate: String, watchNumber: Int, venue: String, seatInfo: String, price: String)? {
        return viewModel.getTicketDetail()
    }
    
    var body: some View {
        DGScreen(horizontalPadding: 0, isLoading: viewModel.isLoading) {
            Group {
                if let ticketDetail = ticketDetail {
                    ticketDetailContent(ticketDetail: ticketDetail)
                } else if !viewModel.isLoading {
                    errorView(message: "티켓 정보를 불러올 수 없습니다.")
                }
            }
        }
    }
    
    
    private func errorView(message: String) -> some View {
        VStack(spacing: 16) {
            Image("alert")
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.error)
            
            Text(message)
                .font(.body1)
                .foregroundColor(.common100)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black)
    }
    
    private func ticketDetailContent(ticketDetail: (title: String, userName: String, watchDate: String, watchNumber: Int, venue: String, seatInfo: String, price: String)) -> some View {
        ScrollView {
            VStack(spacing: 0) {
                BackNavWithTitle(title:"티켓 상세보기"){
                    HStack(spacing: 0) {
                        Button(action: {
                            viewModel.downloadTicket()
                        }) {
                            Image("download")
                        }
                        
                        Button(action: {
                            viewModel.showTicketDetail()
                        }) {
                            Image("detail")
                        }
                    }
                    .foregroundStyle(.common100)
                }
                
                VStack(spacing: 24) {
                    Text(ticketDetail.title)
                        .font(.heading1)
                        .foregroundColor(.common100)
                    
                    ticketCard
                    
                    basicInfoSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                Spacer().frame(height: 120)
            }
        }
        .overlay(
            VStack {
                Spacer()
                bottomButton
            }
        )
    }
    
    private var ticketCard: some View {
        ZStack {
            Image("ticket_base")
            
            OverlappingCirclesShape.ticketDetailPattern()
                .blur(radius: 6)
            
            VStack {
                Text("@\(ticketDetail?.userName ?? "")")
                
                Spacer()
                
                VStack(spacing: 0) {
                    Text("관람 후에 느낀\n나만의 감정을 남겨볼까요?")
                        .font(.label2)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.opacity25)
                    
                    Image("chevron_down_sm")
                        .padding(.bottom, 20)
                    
                    Text("감정 남기기 가기")
                        .font(.headline2)
                        .foregroundColor(.opacity5)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 12)
                }
            }
            .padding(20)
        }
    }

    
    private var basicInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("기본정보")
                .font(.body1)
                .foregroundColor(.common100)
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading, 18)
            
            VStack(spacing: 16) {
                if let ticketDetail = ticketDetail {
                    infoRow(title: "관람일", content: ticketDetail.watchDate, subtitle: "#\(ticketDetail.watchNumber)번째 관람")
                    infoRow(title: "장소", content: ticketDetail.venue)
                    infoRow(title: "좌석", content: ticketDetail.seatInfo)
                    infoRow(title: "가격", content: ticketDetail.price)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 20)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.opacity85, lineWidth: 1)
            )
        }
    }
    
    private func infoRow(title: String, content: String, subtitle: String? = nil) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.label2)
                .foregroundColor(.opacity45)
                .frame(width: 64, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(content)
                    .font(.label2)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.label2)
                }
            }
            
            Spacer()
        }
        .foregroundStyle(.common100)
    }
    
    private var bottomButton: some View {
        Button(action: {
            viewModel.goToDiggingNote()
        }) {
            Text("작성한 디깅노트")
                .font(.body2)
                .foregroundColor(.common100)
                .frame(maxWidth: .infinity, maxHeight: 56, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 12).fill(.pMid))
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 34)
    }
}

// MARK: - Preview
struct TicketDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleTicket = TicketModel.sampleData[0]
        
        TicketDetailView(ticketId: sampleTicket.id.uuidString)
            .preferredColorScheme(.dark)
    }
}
