import SwiftUI

struct AddTicketAutoView: View {
    @StateObject private var viewModel = AddTicketAutoViewModel()
    @StateObject private var popupManager = PopupManager.shared
    @FocusState private var isTextEditorFocused: Bool
    
    let onNavigateToConfirm: (CreateTicketFormData) -> Void
    
    var body: some View {
        DGScreen(backgroundColor: .common0, isAlignCenter: true, onClick: { isTextEditorFocused = false }) {
            BackNavWithTitle(title: "티켓 추가하기",backgroundColor: .common0)
            guidanceSection
                .padding(.top, 32)
            
            textEditorSection
                .padding(.horizontal, 8)
                .padding(.top, 20)
            
            Spacer()
            
            actionButton
                .padding(.horizontal, 8)
                .padding(.bottom, 34)
        }
        .onAppear {
            isTextEditorFocused = true
        }
        .overlay{
            if viewModel.isLoading {
                ZStack {
                    Color.black.opacity(0.3).ignoresSafeArea()
                    Image("processing")
                }
                
            }
        }
    }
}

// MARK: - Components
extension AddTicketAutoView {
    private var guidanceSection: some View {
        Button(action: {
            PopupManager.shared.show(.custom(TicketGuidePopupView()))
        }) {
            VStack(spacing: 8) {
                Text("[안내] 한 번에 1개의 티켓 정보만 등록할 수 있어요.")
                    .fontStyle(.caption1)
                    .foregroundStyle(.neutral100)
                    .multilineTextAlignment(.center)

                HStack(spacing: 4) {
                    Text("가이드 보기")
                        .fontStyle(.caption2)
                        .foregroundStyle(.opacityWhite300)

                    Image("chevron_right")
                        .resizable()
                        .frame(width: 10, height: 10)
                        .foregroundStyle(.neutral300)
                }
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(.opacityWhite50, in: RoundedRectangle(cornerRadius: 24))
    }
    
    private var textEditorSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(.neutral900.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(.neutral100.opacity(0.15), lineWidth: 1.5)
                    )
                    .frame(height: 417)
                
                if viewModel.ticketText.isEmpty {
                    Text("복사한 티켓 정보를 이곳에 붙여 넣어주세요.")
                        .fontStyle(.body1)
                        .foregroundStyle(.neutral400)
                        .padding(.top, 24)
                        .padding(.leading, 20)
                }
                
                TextEditor(text: $viewModel.ticketText)
                    .fontStyle(.body1)
                    .foregroundStyle(.neutral100)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .padding(.top, 20)
                    .padding(.leading, 16)
                    .padding(.trailing, 16)
                    .padding(.bottom, 20)
                    .focused($isTextEditorFocused)
            }
        }
    }
    
    private var actionButton: some View {
        DGButton(
            text :"티켓 정보 추출하기",
            type: .primaryDark,
            isDisabled: viewModel.ticketText.isEmpty
        ) {
            if !viewModel.ticketText.isEmpty {
                viewModel.processTicketText(onSuccess: { ticketFormData in
                    onNavigateToConfirm(ticketFormData)
                })
            }
        }
    }
}

#Preview {
    AddTicketAutoView(onNavigateToConfirm: {_ in })
}
