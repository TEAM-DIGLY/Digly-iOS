import SwiftUI

struct EndCreateTicketView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: EndCreateTicketViewModel
    
    let onAddFeelingTapped: () -> Void
    let onEditTicketTapped: () -> Void
    let onCompleteTapped: () -> Void
    
    init(
        ticketData: CreateTicketFormData,
        onAddFeelingTapped: @escaping () -> Void,
        onEditTicketTapped: @escaping () -> Void,
        onCompleteTapped: @escaping () -> Void
    ) {
        self._viewModel = StateObject(wrappedValue: EndCreateTicketViewModel(ticketData: ticketData))
        self.onAddFeelingTapped = onAddFeelingTapped
        self.onEditTicketTapped = onEditTicketTapped
        self.onCompleteTapped = onCompleteTapped
    }
    
    var body: some View {
        DGScreen(backgroundColor: .common0) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    headerSection
                        .padding(.bottom, 24)
                    
                    successTitleSection
                        .padding(.bottom, 40)
                    
                    feelingCardSection
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    
                    ticketInfoSection
                        .padding(.horizontal, 24)
                        .padding(.bottom, 40)
                    
                    bottomButtonSection
                        .padding(.horizontal, 24)
                        .padding(.bottom, 34)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Components
extension EndCreateTicketView {
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
    
    private var successTitleSection: some View {
        Text("티켓을 등록했어요 !")
            .fontStyle(.heading1)
            .foregroundStyle(.common100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
    }
    
    private var feelingCardSection: some View {
        VStack(spacing: 0) {
            ZStack {
                // Background with animated gradient circles
                gradientBackgroundView
                
                // Content overlay
                VStack(spacing: 16) {
                    Text("@Yeji")
                        .fontStyle(.heading2)
                        .foregroundStyle(.common100)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 19)
                        .padding(.horizontal, 16)
                    
                    Spacer()
                    
                    VStack(spacing: 8) {
                        Text("관람 중에 느낀 나만의 감정을 남겨볼까요?")
                            .fontStyle(.body2)
                            .foregroundStyle(.common100)
                            .multilineTextAlignment(.center)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundStyle(.common100)
                    }
                    .padding(.bottom, 20)
                }
                .frame(height: 298)
            }
            .frame(height: 298)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 16,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 16
                )
            )
            
            // Bottom section with button
            VStack(spacing: 0) {
                // Divider line
                Rectangle()
                    .fill(.neutral700)
                    .frame(height: 1)
                
                // Button area
                Button(action: onAddFeelingTapped) {
                    Text("감정 남기러 가기")
                        .fontStyle(.headline1)
                        .foregroundStyle(.common100)
                        .frame(height: 78)
                        .frame(maxWidth: .infinity)
                        .background(.common0)
                }
            }
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 0,
                    bottomLeadingRadius: 16,
                    bottomTrailingRadius: 16,
                    topTrailingRadius: 0
                )
            )
        }
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(.neutral100.opacity(0.15), lineWidth: 1)
        )
    }
    
    private var gradientBackgroundView: some View {
        ZStack {
            // Multiple overlapping circles to create the gradient effect
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.purple.opacity(0.3), .purple.opacity(0.1), .clear],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .frame(width: 200, height: 200)
                .offset(x: -50, y: -30)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.blue.opacity(0.3), .blue.opacity(0.1), .clear],
                        center: .topTrailing,
                        startRadius: 0,
                        endRadius: 150
                    )
                )
                .frame(width: 200, height: 200)
                .offset(x: 50, y: -20)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [.pink.opacity(0.2), .pink.opacity(0.1), .clear],
                        center: .center,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .frame(width: 180, height: 180)
        }
        .background(.common0)
    }
    
    private var ticketInfoSection: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("기본정보")
                .fontStyle(.heading3)
                .foregroundStyle(.common100)
            
            VStack(spacing: 16) {
                infoRow(label: "관람일", value: viewModel.formattedDate)
                infoRow(label: "", value: viewModel.formattedViewingCount)
                infoRow(label: "장소", value: viewModel.ticketData.place)
                infoRow(label: "좌석", value: viewModel.formattedSeatLocation)
                infoRow(label: "가격", value: viewModel.formattedPrice)
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(.neutral900.opacity(0.05))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(.neutral100.opacity(0.15), lineWidth: 1.5)
                    )
            )
        }
    }
    
    private func infoRow(label: String, value: String) -> some View {
        HStack(alignment: .top, spacing: 16) {
            if !label.isEmpty {
                Text(label)
                    .fontStyle(.body2)
                    .foregroundStyle(.neutral300)
                    .frame(width: 66, alignment: .leading)
            } else {
                Spacer()
                    .frame(width: 66)
            }
            
            Text(value)
                .fontStyle(.body2)
                .foregroundStyle(.common100)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    private var bottomButtonSection: some View {
        VStack(spacing: 16) {
            Button(action: onEditTicketTapped) {
                VStack(spacing: 4) {
                    Text("티켓의 정보가 다른가요?")
                        .fontStyle(.body2)
                        .foregroundStyle(.neutral300)
                    
                    Rectangle()
                        .fill(.neutral600)
                        .frame(width: 133, height: 4)
                        .clipShape(RoundedRectangle(cornerRadius: 2))
                }
                .frame(height: 54)
                .frame(maxWidth: .infinity)
            }
            
            Spacer()
                .frame(height: 32)
        }
    }
}

#Preview {
    let sampleData = CreateTicketFormData()
    
    EndCreateTicketView(
        ticketData: sampleData,
        onAddFeelingTapped: {},
        onEditTicketTapped: {},
        onCompleteTapped: {}
    )
}
