import SwiftUI

struct MyPageView: View {
    @EnvironmentObject private var router: HomeRouter
    @Environment(\.dismiss) private var dismiss
    @StateObject private var authManager = AuthManager.shared
    
    var body: some View {
        DGScreen(horizontalPadding: 0, isAlignCenter: true) {
            VStack(spacing: 0) {
                BackNavWithTitle(title: "마이페이지") {}
                .padding(.horizontal, 8)
                .padding(.top, 8)
                
                ScrollView {
                    VStack(spacing: 0) {
                        profileSection
                            .padding(.horizontal, 40)
                            .padding(.bottom, 40)
                        
                        menuItem(title: "1:1 문의") {}
                        
                        Rectangle()
                            .fill(.common0.opacity(0.05))
                            .frame(height: 3)
                        
                        menuItem(title: "이용약관") {
                            router.push(to: .agreementDetail(.service))
                        }
                        
                        Divider()
                            .padding(.horizontal, 24)
                        
                        menuItem(title: "개인정보 수집 및 이용 동의 내역") {
                            router.push(to: .agreementDetail(.privacy))
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.vertical, 16)
                    
                    logoutButton
                }
            }
        }
    }
    
    // MARK: - Profile Section
    private var profileSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(authManager.avatarImageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 97)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(authManager.diglyType.verb)
                        .fontStyle(.body2)
                        .foregroundStyle(.neutral700)
                    
                    Text(authManager.nickname)
                        .fontStyle(.heading2)
                        .foregroundStyle(.common0)
                }
                
                Spacer()
            }
            
            Button(action: {
            }) {
                HStack(spacing: 10) {
                    Image("edit")
                    
                    Text("프로필 설정")
                        .fontStyle(.label2)
                        .foregroundStyle(.neutral800)
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(.common100,
                            in: RoundedRectangle(cornerRadius: 16)
                )
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 20)
        .padding(.bottom, 16)
        .background(authManager.diglyType.subColor, in:
                        UnevenRoundedRectangle(
                            topLeadingRadius: 0,
                            bottomLeadingRadius: 24,
                            bottomTrailingRadius: 24,
                            topTrailingRadius: 24
                        )
        )
    }
    
    // MARK: - Menu Item
    private func menuItem(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .fontStyle(.body2)
                    .foregroundStyle(.neutral900)
                
                Spacer()
                
                Image("chevron_right")
                    .renderingMode(.template)
                    .foregroundStyle(.neutral400)
            }
            .padding(.horizontal, 32)
            .padding(.vertical, 20)
        }
    }
    
    // MARK: - Logout Button
    private var logoutButton: some View {
        VStack {
            Spacer()
            
            Button(action: {
                PopupManager.shared.show(.logoutWarning { AuthManager.shared.logout() })
            }) {
                Text("로그아웃")
                    .fontStyle(.body2)
                    .foregroundStyle(.common0)
                    .frame(width: 140, alignment: .center)
                    .padding(.vertical, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(.opacityCool200, lineWidth: 1)
                    )
            }
            .padding(.bottom, 16)
        }
    }
}

#Preview {
    MyPageView()
}
