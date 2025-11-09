import SwiftUI

struct OnboardingAgreementPopup: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var authRouter: AuthRouter
    
    @State private var isTermsAccepted: Bool = false
    @State private var isPrivacyAccepted: Bool = false
    let onContinue: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image("diglyIcon")
                    .resizable()
                    .frame(width: 52, height: 52)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("digly")
                        .fontStyle(.top)
                        .foregroundStyle(.opacityBlack850)
                    
                    Text("문화생활의 여운, 일상에서 누리는\n디깅라이프의 시작")
                        .fontStyle(.tiny)
                        .foregroundStyle(.opacityBlack300)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Divider()
            
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .top) {
                    Image(isTermsAccepted && isPrivacyAccepted ? "checkBox_filled" : "checkBox")
                        .resizable()
                        .frame(width: 24, height: 24)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text("전체 동의하기")
                            .fontStyle(.mid)
                            .foregroundStyle(.opacityBlack850)
                        
                        Text("전체동의는 카카오 및 digly의 서비스 동의를 포함하고 있습니다. 전체동의는 선택적인 동의 항목에 대한 동의를 포함하고 있으며, 선택적인 동의 항목에 대한 동의를 거부해도 서비스 이용이 가능합니다.")
                            .fontStyle(.smallMid)
                            .foregroundStyle(.opacityBlack300)
                    }
                    .padding(.top,4)
                }
                .onTapGesture {
                    let newValue = !(isTermsAccepted && isPrivacyAccepted)
                    withAnimation(.fastEaseInOut) {
                        isTermsAccepted = newValue
                        isPrivacyAccepted = newValue
                    }
                }
                
                Divider()
                
                Text("digly 서비스 동의")
                    .fontStyle(.smallBold)
                    .foregroundStyle(.common0)
                    .padding(.leading,26)
                
                HStack {
                    HStack(spacing: 0) {
                        Image("check")
                            .opacity(isTermsAccepted ? 1.0 : 0.2)
                        
                        Text("[필수] 이용약관 동의")
                            .fontStyle(.smallBold)
                            .foregroundStyle(isTermsAccepted ? .opacityBlack850 : .opacityBlack300)
                    }
                    .onTapGesture {
                        withAnimation(.fastEaseInOut) { isTermsAccepted.toggle() }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        authRouter.push(to: .agreementDetail(type: .service))
                    }) {
                        Text("보기")
                            .fontStyle(.smallLine)
                            .foregroundStyle(.neutral600)
                            .overlay(Rectangle()
                                .fill(.neutral600)
                                .frame(height: 1)
                                .offset(y: 0),alignment: .bottom
                            )
                    }
                }

                HStack {
                    HStack(spacing: 0) {
                        Image("check")
                            .opacity(isPrivacyAccepted ? 1.0 : 0.2)
                        
                        Text("[필수] 개인정보 수집 및 이용 동의")
                            .fontStyle(.smallBold)
                            .foregroundStyle(isPrivacyAccepted ? .opacityBlack850 : .opacityBlack300)
                    }
                    .onTapGesture {
                        withAnimation(.fastEaseInOut) { isPrivacyAccepted.toggle() }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        authRouter.push(to: .agreementDetail(type: .privacy))
                    }) {
                        Text("보기")
                            .fontStyle(.smallLine)
                            .foregroundStyle(.neutral600)
                            .overlay(Rectangle()
                                .fill(.neutral600)
                                .frame(height: 1)
                                .offset(y: 0),alignment: .bottom
                            )
                    }
                }
            }
            .padding(.bottom, 8)
            
            Button(action: {
                onContinue()
            }) {
                Text("동의하고 계속하기")
                    .fontStyle(.body1)
                    .foregroundStyle(.common100)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background( (isTermsAccepted && isPrivacyAccepted) ?
                        .opacityCool900 :
                            .opacityBlack100
                    )
                    .cornerRadius(16)
            }
            .disabled(!(isTermsAccepted && isPrivacyAccepted))
            
            Button(action: {
                dismiss()
            }) {
                Text("취소")
                    .fontStyle(.smallLine)
                    .foregroundStyle(.neutral600)
                    .overlay(Rectangle()
                        .fill(.neutral600)
                        .frame(height: 1)
                        .offset(y: 0),alignment: .bottom
                    )
            }
        }
        .padding(.vertical,22)
        .padding(.horizontal,16)
        .background(.common100)
        .cornerRadius(24)
        .padding(.horizontal, 50)
    }
}

// 미리보기
struct OnboardingAgreementPopup_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingAgreementPopup(onContinue: {})
    }
}

