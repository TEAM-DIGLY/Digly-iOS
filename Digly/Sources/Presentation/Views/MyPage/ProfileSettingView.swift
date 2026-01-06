import SwiftUI

struct ProfileSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var router: HomeRouter
    @StateObject private var viewModel = ProfileSettingViewModel()
    @FocusState var isFocused: Bool

    var body: some View {
        DGScreen(horizontalPadding: 0, onClick: {
            isFocused = false
        }) {
            TitleBackNavBar(title: viewModel.isEditMode ? "수정하기" : "프로필 설정", isDarkMode: false) {
                Button(action: {
                    if viewModel.isEditMode {
                        viewModel.saveProfile {
                            dismiss()
                        }
                    } else {
                        viewModel.isEditMode = true
                    }
                }) {
                    Text(viewModel.isEditMode ? "완료" : "수정")
                        .fontStyle(.headline2)
                        .foregroundStyle(.common0)
                        .padding(.horizontal, 8)
                }
            }
            .padding(.bottom, 24)

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
            .opacity(viewModel.isEditMode ? 1.0: 0.6)
            .focused($isFocused)
            .disabled(!viewModel.isEditMode)

            if viewModel.isEditMode {
                nicknameStatusText
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 4)
                    .padding(.top, 4)
            }
        }
    }

    // MARK: - Character Section
    private var characterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("나의 캐릭터")
                .fontStyle(.label2)
                .foregroundStyle(.neutral600)

            Text("# \(viewModel.characters[viewModel.currentCharacterIndex].diglyType.verb) 디글리")
                .fontStyle(.body1)
                .foregroundStyle(.neutral900)

            characterSelector
                .padding(.top, 24)
        }
    }

    // MARK: - Character Selector
    private var characterSelector: some View {
        HStack(alignment:.top, spacing: 12) {
            if viewModel.isEditMode {
                ForEach(Array(Digly.data.enumerated()), id: \.offset) { index, digly in
                    Button(action: {
                        viewModel.currentCharacterIndex = index
                    }) {
                        let isSelected = index == viewModel.currentCharacterIndex
                        VStack(spacing: 12) {
                            Image("\(digly.diglyType.imageName)_avatar_box")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: .infinity)
                                .opacity(isSelected ? 1.0 : 0.2)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 13).stroke(isSelected ? viewModel.isEditMode ? .neutral600 : .neutral300 : .clear, lineWidth: 1)
                                }
                            
                            if isSelected {
                                Image("check")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40)
                            }
                        }
                    }
                    .disabled(!viewModel.isEditMode)
                }
            } else {
                Image("\(AuthManager.shared.diglyType.imageName)_avatar_box")
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(13)
                    .clipped()
            }
        }
    }

    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack(spacing: 16) {
            Text("\(viewModel.getCurrentDateString()) 로그인")
                .fontStyle(.caption2)
                .foregroundStyle(.neutral400)

            Button(action: {
                router.push(to: .withdrawal)
            }) {
                Text("회원 탈퇴")
                    .fontStyle(.body2)
                    .foregroundStyle(.neutral600)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.neutral200, lineWidth: 1)
                    )
            }
        }
    }

    // MARK: - Nickname Status
    @ViewBuilder
    private var nicknameStatusText: some View {
        if viewModel.nicknameErrorText.isEmpty {
            Text(viewModel.isNicknameValid ? "사용 가능한 닉네임입니다." : "*2-7자의 한글/영문/숫자/특수기호 입력 가능")
                .fontStyle(.caption2)
                .foregroundStyle(viewModel.isNicknameValid ? .success : .neutral400)
        } else {
            Text(viewModel.nicknameErrorText)
                .fontStyle(.caption2)
                .foregroundStyle(.error)
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
