import SwiftUI

struct DdayAlertPopup: View {
    @Binding var isPresented: Bool
    let ticket: Ticket
    let onEmotionButtonTap: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isPresented = false
                    }
                }
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            isPresented = false
                        }
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
                
                Image("ticket-base-big-blue")
                    .overlay {
                        VStack(alignment: .leading, spacing: 0) {
                            Text(ticket.name)
                                .fontStyle(.heading1)
                                .foregroundStyle(.common100)
                                .padding(.horizontal, 24)
                                .padding(.vertical, 32)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                HStack(alignment: .top) {
                                    Text("관람일시")
                                        .fontStyle(.label2)
                                        .foregroundStyle(.opacityWhite500)
                                        .frame(width: 64, alignment: .leading)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(ticket.time.toTicketDateString())
                                            .fontStyle(.label2)
                                            .foregroundStyle(.common100)
                                        
                                        Text(ticket.time.toTimeString())
                                            .fontStyle(.label2)
                                            .foregroundStyle(.common100)
                                    }
                                    
                                }
                                
                                HStack(alignment: .top) {
                                    Text("장소")
                                        .fontStyle(.label2)
                                        .foregroundStyle(.opacityWhite500)
                                        .frame(width: 64, alignment: .leading)
                                    
                                    Text(ticket.place)
                                        .fontStyle(.label2)
                                        .foregroundStyle(.common100)
                                        .lineLimit(2)
                                }
                            }
                            .padding(.horizontal, 24)
                            
                            Spacer()
                            
                            Button(action: {
                                onEmotionButtonTap()
                            }) {
                                Text("감정 키워드로 티켓 완성하기")
                                    .fontStyle(.body1)
                                    .foregroundStyle(.pLight)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 12)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(.opacityWhite100)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(.opacityWhite200, lineWidth: 1)
                                            )
                                    )
                            }
                            .padding(.bottom, 16)
                            .padding(.horizontal, 12)
                        }
                        .frame(maxHeight: 376)
                        .padding(.horizontal, 24)
                    }
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        isPresented = false
                    }
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
        }
    }
}

#Preview {
    DdayAlertPopup(
        isPresented: .constant(true),
        ticket: Ticket(
            id: 1,
            name: "프랑켄슈타인",
            time: Date(),
            place: "블루스퀘어 신한카드홀",
            count: 24,
            seatNumber: "@4",
            price: 20000,
            emotions: [.distressed]
        ),
        onEmotionButtonTap: {}
    )
}
