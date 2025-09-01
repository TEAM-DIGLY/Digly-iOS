import SwiftUI

enum TicketCreationType {
    case copyTicket
    case createTicket
    
    var title: String {
        switch self {
        case .copyTicket:
            return "티켓 정보 불러오기"
        case .createTicket:
            return "직접 입력하기"
        }
    }
    
    var description: String {
        switch self {
        case .copyTicket:
            return "예매한 티켓 텍스트를 복사하여 붙여넣으면\n필요한 정보를 자동으로 추출해요."
        case .createTicket:
            return "티켓 정보를 직접 입력해요."
        }
    }
    
    var imageName: String {
        switch self {
        case .copyTicket:
            return "copy_ticket"
        case .createTicket:
            return "create_ticket"
        }
    }
}

struct AddTicketView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: HomeRouter
    @State private var selectedType: TicketCreationType?
    
    var body: some View {
        DGScreen(horizontalPadding: 0, backgroundColor: .common0) {
            BackNavWithTitle(title: "티켓 추가하기", backgroundColor: .common0)
                .padding(.horizontal, 16)
            
            VStack(spacing: 32) {
                TicketOptionCard(
                    type: .copyTicket,
                    isSelected: selectedType == .copyTicket
                ) {
                    selectedType = .copyTicket
                }
                
                TicketOptionCard(
                    type: .createTicket,
                    isSelected: selectedType == .createTicket
                ) {
                    selectedType = .createTicket
                }
            }
            .padding(.horizontal, 52)
            
            Spacer()
            
            DGButton(
                text: "다음으로",
                type: .primaryDark,
                disabled: selectedType == nil) {
                    handleNextButton()
                }
                .padding(.horizontal, 24)
        }
    }
    
    private func handleNextButton() {
        guard let selectedType = selectedType else { return }
        
        switch selectedType {
        case .copyTicket:
            // TODO: 티켓 정보 불러오기 화면으로 이동
            print("티켓 정보 불러오기 선택")
        case .createTicket:
            router.push(to: .createTicketForm)
        }
    }
}

struct TicketOptionCard: View {
    let type: TicketCreationType
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 32) {
                Image(type.imageName)
                
                VStack(spacing: 8) {
                    Text(type.title)
                        .fontStyle(.headline1)
                        .foregroundStyle(.neutral85)
                    
                    Text(type.description)
                        .fontStyle(.body2)
                        .foregroundStyle(.neutral65)
                        .multilineTextAlignment(.center)
                        .lineLimit(nil)
                }
            }
            .padding(.top, 32)
            .padding(.bottom, 24)
            .frame(maxWidth: .infinity)
            .background(Color.neutral5.opacity(0.05), in: RoundedRectangle(cornerRadius: 24))
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(
                        isSelected ? Color.neutral85.opacity(0.65) : Color.neutral85.opacity(0.15),
                        lineWidth: 1.5
                    )
            )
            .opacity(isSelected ? 1.0 : 0.5)
        }
    }
}

#Preview {
    AddTicketView()
}
