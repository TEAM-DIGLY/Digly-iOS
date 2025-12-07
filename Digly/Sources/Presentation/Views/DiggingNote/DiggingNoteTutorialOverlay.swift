import SwiftUI

struct DiggingNoteTutorialOverlay: View {
    let onTapBtn: () -> Void
    let onDismiss: () -> Void
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
                .contentShape(Rectangle())
                .onTapGesture {
                    PopupManager.shared.dismissPopup()
                    onDismiss()
                }
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        onTapBtn()
                        onDismiss()
                        PopupManager.shared.dismissPopup()
                    }) {
                        VStack(spacing: 4) {
                            Image("plus")
                                .resizable()
                                .frame(width: 16, height: 16)
                            
                            Text("노트 추가")
                                .font(.label2)
                                .foregroundColor(.opacityWhite800)
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 72)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.bottomSheetBackground)
                                .stroke(.opacityWhite200, lineWidth: 1)
                        )
                        .shadow(color: .common100.opacity(0.3),radius: 8)
                    }
                }
                .padding(.top, 32)
                .padding(.bottom, 8)
                .padding(.horizontal, 24)
                
                Text("새로운 관람 노트를 추가해 보세요")
                    .font(.label1)
                    .foregroundStyle(.neutral50)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(.grayscale700, in: UnevenRoundedRectangle(topLeadingRadius: 8,bottomLeadingRadius: 8,bottomTrailingRadius: 8))
                
                    .overlay {  UnevenRoundedRectangle(topLeadingRadius: 8,bottomLeadingRadius: 8,bottomTrailingRadius: 8)
                            .stroke(.grayscale400, lineWidth: 1)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 24)
                Spacer()
            }
        }
    }
}

#Preview {
    DiggingNoteTutorialOverlay(
        onTapBtn: {},
        onDismiss: {}
    )
}
