import SwiftUI

struct ProfileSettingView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authManager = AuthManager.shared
    @State private var nickname: String = ""
    @State private var currentCharacterIndex: Int = 0
    
    private let characters = Digly.data
    
    var body: some View {
        ZStack {
            Color.clear
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Navigation Bar
                navigationBar
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Nickname Section
                        nicknameSection
                            .padding(.horizontal, 24)
                            .padding(.top, 32)
                        
                        // Character Section
                        characterSection
                            .padding(.horizontal, 24)
                        
                        Spacer(minLength: 100)
                    }
                }
            }
            
            // Bottom Section
            VStack {
                Spacer()
                
                bottomSection
                    .padding(.horizontal, 24)
                    .padding(.bottom, 34)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            nickname = authManager.nickname
            currentCharacterIndex = characters.firstIndex { $0.diglyType == authManager.diglyType } ?? 0
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
                    .foregroundStyle(.neutral5)
            }
            
            Spacer()
            
            Text("프로필 설정")
                .fontStyle(.headline2)
                .foregroundStyle(.neutral5)
            
            Spacer()
            
            Button(action: {
                // Save action
                saveProfile()
            }) {
                Text("수정")
                    .fontStyle(.body2)
                    .foregroundStyle(.neutral5)
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
                .foregroundStyle(.neutral35)
            
            DGTextField.profileStyle(text: $nickname)
        }
    }
    
    // MARK: - Character Section
    private var characterSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("나의 캐릭터")
                .fontStyle(.body2)
                .foregroundStyle(.neutral35)
            
            Text("# \(characters[currentCharacterIndex].role)")
                .fontStyle(.body2)
                .foregroundStyle(.neutral15)
            
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
                    currentCharacterIndex = (currentCharacterIndex - 1 + characters.count) % characters.count
                }
            }) {
                Image("chevron_left")
                    .renderingMode(.template)
                    .foregroundStyle(.neutral45)
                    .frame(width: 24, height: 24)
            }
            .padding(.leading, 20)
            
            Spacer()
            
            // Character Display
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.neutral85)
                        .frame(width: 120, height: 160)
                    
                    Image(characters[currentCharacterIndex].diglyType.profileImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 120)
                }
                
                Image("chevron_down_sm")
                    .renderingMode(.template)
                    .foregroundStyle(.neutral55)
            }
            
            Spacer()
            
            // Right Arrow
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    currentCharacterIndex = (currentCharacterIndex + 1) % characters.count
                }
            }) {
                Image("chevron_right")
                    .renderingMode(.template)
                    .foregroundStyle(.neutral45)
                    .frame(width: 24, height: 24)
            }
            .padding(.trailing, 20)
        }
    }
    
    // MARK: - Bottom Section
    private var bottomSection: some View {
        VStack(spacing: 16) {
            Text("\(getCurrentDateString()) 로그인")
                .fontStyle(.caption2)
                .foregroundStyle(.neutral55)
            
            Button(action: {
                // Withdrawal action
            }) {
                Text("회원 탈퇴")
                    .fontStyle(.body2)
                    .foregroundStyle(.neutral35)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.neutral75, lineWidth: 1)
                    )
            }
        }
    }
    
    // MARK: - Helper Methods
    private func getCurrentDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: Date())
    }
    
    // MARK: - Save Profile
    private func saveProfile() {
        // Update nickname
        authManager.updateNickname(nickname)
        
        // Update character
        authManager.updateDiglyType(characters[currentCharacterIndex].diglyType)
        
        dismiss()
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
