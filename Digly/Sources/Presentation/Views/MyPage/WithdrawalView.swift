import SwiftUI

struct WithdrawalView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = WithdrawalViewModel()
    @FocusState private var isCustomReasonFocused: Bool

    var body: some View {
        DGScreen(horizontalPadding: 0, onClick: {
            isCustomReasonFocused = false
        }) {
            TitleBackNavBar(title: "탈퇴하기", isDarkMode: false) {VStack{}}
                .padding(.bottom, 24)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 40) {
                    warningSection
                        .padding(.horizontal, 24)
                        .padding(.top, 8)

                    reasonSection
                        .padding(.horizontal, 24)

                    Spacer(minLength: 100)
                }
            }
        }
        .overlay(alignment: .bottom) {
            bottomSection
                .padding(.horizontal, 24)
                .padding(.bottom, 34)
        }
    }

    // MARK: - Warning Section
    private var warningSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("\(viewModel.nickname)님이 digly와 함께 한\n\(viewModel.memberSinceDays)일의 기록이 사라져요")
                .fontStyle(.headline1)
                .foregroundStyle(.neutral900)
                .lineSpacing(0)

            Text("탈퇴하면 \(viewModel.nickname)님이 기록한 티켓과 감정, 디깅노트를\n포함한 모든 정보가 삭제돼요.\n탈퇴 후에는 7일간 재가입이 불가능해요.")
                .fontStyle(.label1)
                .foregroundStyle(.opacityCool500)
                .lineSpacing(0)
        }
    }

    // MARK: - Reason Section
    private var reasonSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("digly를 떠나는 이유가 궁금해요")
                .fontStyle(.headline1)
                .foregroundStyle(.neutral900)

            dropdownField

            if viewModel.selectedReason == .other {
                customReasonTextField
                    .padding(.top, 8)
            }
        }
    }

    // MARK: - Dropdown Field
    private var dropdownField: some View {
        VStack(spacing: 0) {
            Button(action: {
                viewModel.toggleDropdown()
            }) {
                HStack {
                    Text(viewModel.selectedReason?.displayText ?? "선택해주세요")
                        .fontStyle(.headline1)
                        .foregroundStyle(viewModel.selectedReason == nil ? .neutral400 : .common0)

                    Spacer()

                    Image("chevron_left")
                        .renderingMode(.template)
                        .foregroundStyle(.neutral400)
                        .rotationEffect(.degrees(viewModel.isDropdownExpanded ? 90 : -90))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .frame(height: 52)
                .background(.neutral50, in: RoundedRectangle(cornerRadius: 14))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(viewModel.isDropdownExpanded ? .neutral300 : .clear, lineWidth: 1.5)
                )
            }

            if viewModel.isDropdownExpanded {
                dropdownMenu
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    // MARK: - Dropdown Menu
    private var dropdownMenu: some View {
        VStack(spacing: 8) {
            ForEach(WithdrawalReason.allCases, id: \.self) { reason in
                Button(action: {
                    viewModel.selectReason(reason)
                }) {
                    Text(reason.displayText)
                        .fontStyle(.headline1)
                        .foregroundStyle(.common0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 2)
                        .padding(.vertical, 12)
                }

                if reason != WithdrawalReason.allCases.last {
                    Divider()
                        .background(.opacityCool200)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.neutral50, in: RoundedRectangle(cornerRadius: 14))
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(.neutral300, lineWidth: 1.5)
        )
        .padding(.top, 4)
    }

    // MARK: - Custom Reason Text Field
    private var customReasonTextField: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField("", text: $viewModel.customReasonText, prompt: Text("사유를 입력해주세요").font(.headline1).foregroundColor(.neutral400))
                .focused($isCustomReasonFocused)
                .fontStyle(.headline1)
                .foregroundStyle(.common0)
                .padding(.horizontal, 16)
                .frame(height: 56)
                .background(.neutral50, in: RoundedRectangle(cornerRadius: 16))
                .textInputLimit(text: $viewModel.customReasonText, maxLength: 100)

            Text("\(viewModel.customReasonText.count)/100")
                .fontStyle(.caption2)
                .foregroundStyle(.neutral400)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 4)
        }
    }

    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack(spacing: 16) {
            // Digly character image would go here
            // For now using a placeholder
            Image(AuthManager.shared.avatarImageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 60)
                .opacity(0.8)

            Button(action: {
                viewModel.performWithdrawal {
                    dismiss()
                }
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .common0))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 17)
                                .stroke(.opacityCool200, lineWidth: 1.5)
                        )
                        .background(.neutral50, in: RoundedRectangle(cornerRadius: 17))
                } else {
                    Text("탈퇴하기")
                        .fontStyle(.body2)
                        .foregroundStyle(.common0)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 17)
                                .stroke(.opacityCool200, lineWidth: 1.5)
                        )
                        .background(.neutral50, in: RoundedRectangle(cornerRadius: 17))
                }
            }
            .disabled(!viewModel.isWithdrawButtonEnabled || viewModel.isLoading)
            .opacity(viewModel.isWithdrawButtonEnabled ? 1.0 : 0.5)
        }
    }
}

#Preview {
    WithdrawalView()
}
