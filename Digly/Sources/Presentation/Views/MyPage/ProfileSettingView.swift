import SwiftUI

struct ProfileSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = ProfileSettingViewModel()

    var body: some View {
        DGScreen(horizontalPadding: 0) {
            navigationBar

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 24) {
                    nicknameSection
                        .padding(.horizontal, 24)
                        .padding(.top, 32)

                    characterSection
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
        .onAppear {
            viewModel.onAppear()
        }
    }

    // MARK: - Navigation Bar
    private var navigationBar: some View {
        HStack {
            Button(action: {
                dismiss()
            }) {
                Image("chevron_left")
                    .renderingMode(.template)
                    .foregroundStyle(.neutral900)
            }

            Spacer()

            Text("프로필 설정")
                .fontStyle(.headline2)
                .foregroundStyle(.neutral900)

            Spacer()

            Button(action: {
                viewModel.saveProfile {
                    dismiss()
                }
            }) {
                Text("수정")
                    .fontStyle(.body2)
                    .foregroundStyle(.neutral900)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }

    // MARK: - Nickname Section
    private var nicknameSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("닉네임")
                .fontStyle(.body2)
                .foregroundStyle(.neutral600)

            DGTextField(
                text: $viewModel.nickname,
                placeholder: "",
                type: .profileSetting
            )
        }
    }

    // MARK: - Character Section
    private var characterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("나의 캐릭터")
                .fontStyle(.body2)
                .foregroundStyle(.neutral600)

            Text("# \(viewModel.characters[viewModel.currentCharacterIndex].role)")
                .fontStyle(.body2)
                .foregroundStyle(.neutral800)

            // Character Selector
            characterSelector
                .padding(.top, 24)
        }
    }

    // MARK: - Character Selector
    private var characterSelector: some View {
        HStack(spacing: 0) {
            // Left Arrow
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.selectPreviousCharacter()
                }
            }) {
                Image("chevron_left")
                    .renderingMode(.template)
                    .foregroundStyle(.neutral500)
                    .frame(width: 24, height: 24)
            }
            .padding(.leading, 20)

            Spacer()

            // Character Display
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.neutral100)
                        .frame(width: 120, height: 160)

                    Image(viewModel.characters[viewModel.currentCharacterIndex].diglyType.profileImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                }

                Image("chevron_down_sm")
                    .renderingMode(.template)
                    .foregroundStyle(.neutral400)
            }

            Spacer()

            // Right Arrow
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    viewModel.selectNextCharacter()
                }
            }) {
                Image("chevron_right")
                    .renderingMode(.template)
                    .foregroundStyle(.neutral500)
                    .frame(width: 24, height: 24)
            }
            .padding(.trailing, 20)
        }
    }

    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack(spacing: 16) {
            Text("\(viewModel.getCurrentDateString()) 로그인")
                .fontStyle(.caption2)
                .foregroundStyle(.neutral400)

            Button(action: {
                viewModel.showWithdrawalConfirmation()
            }) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .neutral600))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.neutral200, lineWidth: 1)
                        )
                } else {
                    Text("회원 탈퇴")
                        .fontStyle(.body2)
                        .foregroundStyle(.neutral600)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(.neutral200, lineWidth: 1)
                        )
                }
            }
            .disabled(viewModel.isLoading)
        }
    }
}

// MARK: - DiglyType Extension for Profile Image
extension DiglyType {
    var profileImageName: String {
        switch self {
        case .collector:
            return "collector_profile"
        case .analyst:
            return "analyst_profile"
        case .communicator:
            return "communicator_profile"
        }
    }
}

#Preview {
    ProfileSettingView()
}
