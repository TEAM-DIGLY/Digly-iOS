import SwiftUI

struct DdayAlertPopup: View {
    let tickets: [TicketSummary]
    let onEmotionButtonTap: (TicketSummary) -> Void
    
    @State private var currentIndex: Int = 0
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        PopupManager.shared.dismissPopup()
                    }) {
                        Image("close")
                            .padding(16)
                    }
                }
                .padding(.horizontal, 16)
                
                Text("오늘의 관람, 즐거우셨나요?")
                    .fontStyle(.title2)
                    .foregroundStyle(.opacityWhite900)
                    .padding(.top, 36)
                
                Text("관람을 마쳤다면, 기억을 감정으로 남겨보세요")
                    .fontStyle(.body1)
                    .foregroundStyle(.opacityWhite800)
                    .padding(.top, 10)
                
                TabView(selection: $currentIndex) {
                    ForEach(Array(tickets.enumerated()), id: \.element.id) { index, ticketSummary in
                        TicketItem(
                            ticket: Ticket(
                                id: ticketSummary.id,
                                name: ticketSummary.name,
                                time: ticketSummary.performanceTime,
                                place: ticketSummary.place,
                                count: 1,
                                seatNumber: nil,
                                price: nil,
                                emotions: ticketSummary.emotions
                            ),
                            ticketStatus: ticketSummary.emotions.isEmpty ? .summary : .hasEmotions,
                            onTapAddEmotion: { onEmotionButtonTap(ticketSummary) }
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .frame(height: 420)
                .padding(.vertical, 16)
                
                if tickets.count > 1 {
                    HStack(spacing: 8) {
                        ForEach(0..<tickets.count, id: \.self) { index in
                            Circle()
                                .fill(index == currentIndex ? Color.common100 : Color.opacityWhite400)
                                .frame(width: 8, height: 8)
                                .animation(.easeInOut, value: currentIndex)
                        }
                    }
                    .padding(.bottom, 24)
                }
                
                Button(action: {
                    PopupManager.shared.dismissPopup()
                }) {
                    Text("다음에 남길게요")
                        .fontStyle(.label1)
                        .foregroundStyle(.common100)
                        .underline()
                        .overlay(
                            Rectangle()
                                .fill(.common100)
                                .frame(height: 1)
                                .offset(y: 0),
                            alignment: .bottom
                        )
                }
            }
            .padding(.top, 24)
        }
    }
}

#Preview {
    DdayAlertPopup(
        tickets: [
            TicketSummary(
                id: 1,
                name: "프랑켄슈타인",
                performanceTime: Date(),
                place: "블루스퀘어 신한카드홀",
                emotions: [.excited]
            ),
            TicketSummary(
                id: 2,
                name: "시카고",
                performanceTime: Date().addingTimeInterval(3600),
                place: "디큐브 링크아트센터",
                emotions: []
            )
        ],
        onEmotionButtonTap: { _ in }
    )
}
