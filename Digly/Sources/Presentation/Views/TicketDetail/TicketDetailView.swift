import SwiftUI

struct TicketDetailView: View {
    @StateObject var viewModel: TicketDetailViewModel = TicketDetailViewModel()
    
    let ticketId: Int
    
    var body: some View {
        DGScreen(
            horizontalPadding: 0,
            backgroundColor: .common0,
            isLoading: viewModel.isLoading
        ) {
            if let ticket = viewModel.ticket {
                ScrollView(.vertical, showsIndicators: false) {
                    TitleBackNavBar(title: "티켓 상세보기") {
                        HStack(spacing: 24) {
                            Button(action: {
                                // TODO: Download action
                            }) {
                                Image("download")
                            }

                            Button(action: {
                                // TODO: More options
                            }) {
                                Image("detail")
                            }
                        }
                    }
                    .padding(.bottom, 32)
                    
                    Text(ticket.name)
                        .fontStyle(.heading1)
                        .foregroundStyle(.common100)
                        .padding(.bottom, 12)
                    
                    ticketCard(ticket: ticket)
                    
                    basicInfoSection(ticket: ticket)
                    
                    Spacer().frame(height: 120)
                }
                .overlay(
                    VStack {
                        Spacer()
                        DGButton(text: "작성한 디깅노트", type:.primaryDark){
                            viewModel.goToDiggingNote()
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 34)
                    }
                )
            }
        }
        .onAppear {
            viewModel.getTicketDetail(id: ticketId)
        }
    }
    
    private func ticketCard(ticket: Ticket) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 24)
                .fill(.neutral15)
                .frame(height: 376)

            HStack {
                Circle()
                    .fill(.common0)
                    .frame(width: 28, height: 28)
                    .offset(x: -14)

                Spacer()

                Circle()
                    .fill(.common0)
                    .frame(width: 28, height: 28)
                    .offset(x: 14)
            }
            .frame(maxWidth: .infinity)

            // Gradient background with ticket colors
            if !ticket.color.isEmpty {
                LinearGradient(
                    colors: ticket.color.map { $0.color },
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .blur(radius: 6)
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(2)
            }

            VStack(spacing: 16) {
                Text("@Yeji")
                    .fontStyle(.title3)
                    .foregroundStyle(.common100)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()

                if viewModel.hasEmotions {
                    // Show emotions
                    VStack(spacing: 16) {
                        Rectangle()
                            .fill(.opacityWhite25)
                            .frame(height: 1)

                        HStack(spacing: 8) {
                            ForEach(ticket.feeling.prefix(2), id: \.self) { emotion in
                                Text("#\(emotion.rawValue)")
                                    .fontStyle(.body1)
                                    .foregroundStyle(.common100)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(.opacityWhite35, lineWidth: 1)
                                    )
                            }
                            Spacer()
                        }
                    }
                } else {
                    // Show emotion input prompt
                    VStack(spacing: 16) {
                        Text("관람 중에 느낀 나만의 감정을 남겨볼까요?")
                            .fontStyle(.body2)
                            .foregroundStyle(.opacityWhite25)
                            .multilineTextAlignment(.center)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.opacityWhite45)

                        Text("감정 남기러 가기")
                            .fontStyle(.title3)
                            .foregroundStyle(.common100)
                    }
                }
            }
            .padding(24)
        }
        .frame(width: 279, height: 376)
        .padding(.horizontal, 48)
    }

    
    private func basicInfoSection(ticket: Ticket) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("기본정보")
                .fontStyle(.heading2)
                .foregroundStyle(.common100)
                .frame(maxWidth: .infinity, alignment: .leading)

            VStack(spacing: 21) {
                infoRow(title: "관람일", content: formatDate(ticket.time), subtitle: "#\(ticket.count)번째 관람")
                infoRow(title: "장소", content: ticket.place)
                if let seatNumber = ticket.seatNumber {
                    infoRow(title: "좌석", content: seatNumber)
                }
                if let price = ticket.price {
                    infoRow(title: "가격", content: "\(price.formatted())원")
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 40)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(.opacityWhite85, lineWidth: 1)
            )
        }
        .padding(.horizontal, 24)
    }
    
    private func infoRow(title: String, content: String, subtitle: String? = nil) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(title)
                .fontStyle(.body2)
                .foregroundStyle(.opacityWhite45)
                .frame(width: 66, alignment: .leading)

            VStack(alignment: .leading, spacing: 6) {
                Text(content)
                    .fontStyle(.body2)
                    .foregroundStyle(.common100)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .fontStyle(.body2)
                        .foregroundStyle(.common100)
                }
            }

            Spacer()
        }
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 MM월 dd일 (E) HH:mm"
        return formatter.string(from: date)
    }
}
