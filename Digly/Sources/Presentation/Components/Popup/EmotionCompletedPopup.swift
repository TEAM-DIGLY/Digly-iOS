import SwiftUI

struct EmotionCompletedPopup: View {
    let ticket: Ticket
    let selectedEmotions: [Emotion]
    let onViewRecord: () -> Void
    let onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        onDismiss()
                    }
                }

            VStack(spacing: 0) {
                // Close button
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut) {
                            onDismiss()
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 18))
                            .foregroundStyle(.common100)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // Title
                Text("감정이 등록되었어요!")
                    .fontStyle(.title3)
                    .foregroundStyle(.common100)
                    .padding(.top, 24)

                // Subtitle
                Text("[\(ticket.name)]")
                    .fontStyle(.body1)
                    .foregroundStyle(.common100)
                    .padding(.top, 8)

                // Ticket with gradient
                ZStack {
                    Image("ticket-base-big")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 279, height: 376)

                    // Emotion gradient overlay
                    if !selectedEmotions.isEmpty {
                        gradientView(for: selectedEmotions)
                            .frame(width: 279, height: 376)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                            .opacity(0.5)
                    }

                    VStack(alignment: .leading, spacing: 0) {
                        Spacer()

                        Text("@\(ticket.name)")
                            .fontStyle(.heading1)
                            .foregroundStyle(.common100)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 24)

                        Divider()
                            .background(.common100.opacity(0.2))
                            .padding(.horizontal, 27.5)
                            .padding(.bottom, 24)

                        // Emotion tags
                        HStack(spacing: 8) {
                            ForEach(selectedEmotions, id: \.self) { emotion in
                                Text("#\(emotion.rawValue)")
                                    .fontStyle(.body1)
                                    .foregroundStyle(emotion.color)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(
                                        emotion.color50,
                                        in: RoundedRectangle(cornerRadius: 8)
                                    )
                            }
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                    }
                    .frame(width: 279, height: 376)
                }
                .padding(.top, 32)

                // View record button
                Button(action: {
                    onViewRecord()
                }) {
                    Text("감정기록 보러 가기")
                        .fontStyle(.label1)
                        .foregroundStyle(.neutral600)
                        .overlay(
                            Rectangle()
                                .fill(.neutral600)
                                .frame(height: 1)
                                .offset(y: 0),
                            alignment: .bottom
                        )
                }
                .padding(.top, 24)
                .padding(.bottom, 40)
            }
            .frame(maxWidth: .infinity)
        }
    }

    @ViewBuilder
    private func gradientView(for emotions: [Emotion]) -> some View {
        if emotions.count == 1 {
            emotions[0].color
        } else if emotions.count == 2 {
            LinearGradient(
                colors: [emotions[0].color, emotions[1].color],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            Color.clear
        }
    }
}

#Preview {
    EmotionCompletedPopup(
        ticket: Ticket(
            id: 1,
            name: "프랑켄슈타인",
            time: Date(),
            place: "블루스퀘어 신한카드홀",
            count: 2,
            seatNumber: "24",
            price: 2000,
            emotions: [.distressed]
        ),
        selectedEmotions: [.relaxed, .glad],
        onViewRecord: {},
        onDismiss: {}
    )
}
