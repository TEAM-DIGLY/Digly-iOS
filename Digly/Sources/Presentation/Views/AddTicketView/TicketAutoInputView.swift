import SwiftUI

struct TicketAutoInputView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = TicketAutoInputViewModel()
    @State private var showGuidePopup: Bool = false
    @FocusState private var isTextEditorFocused: Bool
    
    var body: some View {
        DGScreen(backgroundColor: .common0, onClick: { isTextEditorFocused = false }) {
            BackNavWithTitle(
                title: "티켓 추가하기",
                backgroundColor: .common0
            ) {
                dismiss()
            }
            .padding(.horizontal, 16)
            
            VStack(spacing: 0) {
                guidanceSection
                    .padding(.horizontal, 48.5)
                    .padding(.top, 32)
                
                textEditorSection
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                
                Spacer()
                
                actionButton
                    .padding(.horizontal, 24)
                    .padding(.bottom, 34)
            }
        }
        .sheet(isPresented: $showGuidePopup) {
            TicketGuidePopupView()
        }
        .onAppear {
            isTextEditorFocused = true
        }
    }
}

// MARK: - Components
extension TicketAutoInputView {
    private var guidanceSection: some View {
        VStack(spacing: 14) {
            Text("[안내] 한 번에 1개의 티켓 정보만 등록할 수 있어요.")
                .fontStyle(.body2)
                .foregroundStyle(.neutral65)
                .multilineTextAlignment(.center)
            
            Button(action: {
                showGuidePopup = true
            }) {
                HStack(spacing: 5) {
                    Text("가이드 보기")
                        .fontStyle(.body2)
                        .foregroundStyle(.neutral65)
                        .underline()
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 8, weight: .medium))
                        .foregroundStyle(.neutral65)
                }
            }
        }
    }
    
    private var textEditorSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 14)
                    .fill(.neutral5.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(.neutral85.opacity(0.15), lineWidth: 1.5)
                    )
                    .frame(height: 417)
                
                if viewModel.ticketText.isEmpty {
                    Text("복사한 티켓 정보를 이곳에 붙여 넣어주세요.")
                        .fontStyle(.body1)
                        .foregroundStyle(.neutral55)
                        .padding(.top, 24)
                        .padding(.leading, 20)
                }
                
                TextEditor(text: $viewModel.ticketText)
                    .fontStyle(.body1)
                    .foregroundStyle(.neutral85)
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
            text: viewModel.isProcessing ? "티켓 정보 추출하기" : (viewModel.ticketText.isEmpty ? "다음으로" : "티켓 정보 추출하기"),
            type: .primaryDark,
            disabled: viewModel.ticketText.isEmpty
        ) {
            if !viewModel.ticketText.isEmpty {
                viewModel.extractTicketInfo()
            }
        }
    }
}

#Preview {
    TicketAutoInputView()
}