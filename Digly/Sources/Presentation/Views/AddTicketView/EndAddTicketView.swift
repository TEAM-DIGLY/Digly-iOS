import SwiftUI

struct EndAddTicketManualView: View {
    @State var isEmotionSheetPresent = false
    @State var ticket: Ticket
    let onCompleteTapped: () -> Void
    let ticketUseCase: TicketUseCase
    
    init(
        ticket: Ticket,
        onCompleteTapped: @escaping () -> Void,
        ticketUseCase: TicketUseCase = TicketUseCase()
    ) {
        self.ticket = ticket
        self.onCompleteTapped = onCompleteTapped
        self.ticketUseCase = ticketUseCase
    }
    
    var body: some View {
        DGScreen(backgroundColor: .common0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                        .padding(.bottom, 24)
                    
                    Text("티켓을 등록했어요 !")
                        .fontStyle(.heading1)
                        .foregroundStyle(.common100)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    
                    TicketDetailContent(
                        ticket: ticket,
                        onTapAddEmotion: { isEmotionSheetPresent = true },
                        onTapNoteItem: {_ in}
                    )
                }
            }
        }
        .sheet(isPresented: $isEmotionSheetPresent) {
            EmotionSelectionBottomSheet(
                currentEmotions: ticket.emotions,
                updateEmotion: { emotions in
                    updateTicketEmotions(emotions)
                    isEmotionSheetPresent = false
                }
            )
            .presentationDetents([.height(600)])
            .presentationDragIndicator(.hidden)
            .presentationCornerRadius(24)
            .presentationBackground(.clear)
        }
    
    }
}

// MARK: - Components
extension EndAddTicketManualView {
    private var headerSection: some View {
        BackNavWithTitle(
            title: "티켓 추가하기",
            backgroundColor: .common0
        ) {
            Button("완료") {
                onCompleteTapped()
            }
            .fontStyle(.headline2)
            .foregroundStyle(.common100)
        }
        .padding(.horizontal, 24)
        .padding(.top, 16)
    }
}

extension EndAddTicketManualView {
    private func updateTicketEmotions(_ emotions: [Emotion]) {
        Task {
            do {
                ticket = try await ticketUseCase.updateTicketEmotions(
                    ticketId: ticket.id,
                    emotions: emotions
                )

                ToastManager.shared.show(.success("감정이 성공적으로 등록되었습니다"))
            } catch {
                ToastManager.shared.show(.errorStringWithTask("감정 등록"))
            }
        }
    }
}

#Preview {
    EndAddTicketManualView(
        ticket: Ticket.dummy,
        onCompleteTapped: {}
    )
}
