import SwiftUI

struct OnboardingDetailView: View {
    @Binding var isPresented: Bool
    @State private var isTermsAccepted: Bool = false
    @State private var isPrivacyAccepted: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        isPresented = false
                    }
                }
            
            VStack(spacing: 16) {
                HStack(spacing: 8) {
                    Image("diglyIcon")
                        .resizable()
                        .frame(width: 52, height: 52)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("digly")
                            .fontStyle(.body1)
                            .foregroundStyle(.opacity5)
                        
                        Text("문화생활의 여운, 일상에서 누리는\n디깅라이프의 시작")
                            .fontStyle(.tiny)
                            .foregroundStyle(.opacity65)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Divider()
                
                VStack(alignment: .leading, spacing: 16) {
                    // 전체 동의하기
                    HStack(alignment: .top) {
                        Image(isTermsAccepted && isPrivacyAccepted ? "checkBox_filled" : "checkBox")
                            .resizable()
                            .frame(width: 24, height: 24)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("전체 동의하기")
                                .fontStyle(.label2)
                                .foregroundStyle(.opacity5)
                            
                            Text("전체동의는 카카오 및 digly의 서비스 동의를 포함하고 있습니다. 전체동의는 선택적인 동의 항목에 대한 동의를 포함하고 있으며, 선택적인 동의 항목에 대한 동의를 거부해도 서비스 이용이 가능합니다.")
                                .fontStyle(.smallLine)
                                .foregroundStyle(.opacity65)
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
                                .foregroundStyle(isTermsAccepted ? .opacity5 : .opacity65)
                        }
                        .onTapGesture {
                            withAnimation(.fastEaseInOut) { isTermsAccepted.toggle() }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // 개인정보 보기 액션
                        }) {
                            Text("보기")
                                .fontStyle(.smallLine)
                                .foregroundStyle(.neutral35)
                                .overlay(Rectangle()
                                    .fill(.neutral35)
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
                                .foregroundStyle(isPrivacyAccepted ? .opacity5 : .opacity65)
                        }
                        .onTapGesture {
                            withAnimation(.fastEaseInOut) { isPrivacyAccepted.toggle() }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // 개인정보 보기 액션
                        }) {
                            Text("보기")
                                .fontStyle(.smallLine)
                                .foregroundStyle(.neutral35)
                                .overlay(Rectangle()
                                    .fill(.neutral35)
                                    .frame(height: 1)
                                    .offset(y: 0),alignment: .bottom
                                )
                        }
                    }
                }
                .padding(.bottom, 8)
                
                Button(action: {
                    // 동의하고 계속하기 액션
                }) {
                    Text("동의하고 계속하기")
                        .fontStyle(.body1)
                        .foregroundStyle(.common100)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background( (isTermsAccepted && isPrivacyAccepted) ?
                            .opacityCool0 :
                                .opacity85
                        )
                        .cornerRadius(16)
                }
                .disabled(!(isTermsAccepted && isPrivacyAccepted))
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        isPresented = false
                    }
                }) {
                    Text("취소")
                        .fontStyle(.smallLine)
                        .foregroundStyle(.neutral35)
                        .overlay(Rectangle()
                            .fill(.neutral35)
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
}

// 미리보기
struct OnboardingDetailView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingDetailView(isPresented: .constant(true))
    }
}

