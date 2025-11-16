import SwiftUI

struct CreateAccountView: View {
    let accessToken: String
    let refreshToken: String
    
    @StateObject private var viewModel: CreateAccountViewModel
    @FocusState private var isFocused : Bool
    @EnvironmentObject private var authRouter: AuthRouter
    
    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self._viewModel = StateObject(wrappedValue: CreateAccountViewModel(accessToken: accessToken, refreshToken: refreshToken))
    }
    
    var body: some View {
        DGScreen(isAlignCenter: true, isLoading: viewModel.isLoading) {
            Button(action:{
                if viewModel.isSelectingDigly {
                    viewModel.isSelectingDigly = false
                } else {
                    authRouter.pop()
                }
            }){
                Image("chevron_left")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(.common0)
                    .frame(width: 56, height: 56)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 16)
            
            LiveDigly(
                isSurprised: isFocused,
                readingValue: viewModel.username,
                onStareUp: viewModel.isSelectingDigly
            )
            
            Group {
                if !viewModel.isSelectingDigly {
                    usernameSection
                        .padding(.top, 48)
                } else {
                    diglySection
                }
            }
            .padding(.horizontal, 12)
            
            Spacer()
        }
        .background(.common100)
        .navigationBarBackButtonHidden()
        .toolbar(.hidden)
        .onTapGesture { isFocused = false }
        
        .overlay(alignment: .bottom) {
            if !viewModel.username.isEmpty {
                DGButton(
                    text: viewModel.isSelectingDigly ? "\(Digly.data[viewModel.selectedIndex].role)하는 디글러 선택하기" : "다음으로",
                    type: .primaryDark,
                    disabled: !viewModel.errorText.isEmpty
                ){
                    if viewModel.isSelectingDigly {
                        viewModel.performSignUp { signUpResponse in
                            let selectedDiglyType = Digly.data[viewModel.selectedIndex].diglyType
                            authRouter.push(to: .onboardingConfirm(
                                signUpResponse: signUpResponse,
                                accessToken: accessToken,
                                refreshToken: refreshToken,
                                diglyType: selectedDiglyType
                            ))
                        }
                    } else {
                        viewModel.handleSubmit()
                    }
                }
                .disabled(!viewModel.errorText.isEmpty)
                .padding(.horizontal, 24)
                .padding(.bottom, 12)
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.mediumSpring, value: viewModel.username.isEmpty)
    }
    
    @ViewBuilder
    private var usernameSection : some View {
        VStack(spacing: 0){
            VStack(spacing: 16) {
                Text("만나서 반가워요!")
                    .fontStyle(.title3)
                    .foregroundStyle(.neutral900)
                
                Text("앞으로 당신을\n어떻게 부를까요?")
                    .fontStyle(.title3)
                    .foregroundStyle(.neutral900)
                    .multilineTextAlignment(.center)
            }
            .padding(.bottom,24)
            
            TextField("", text: $viewModel.username, prompt: Text("이름").foregroundColor(.neutral300))
                .fontStyle(.title2)
                .foregroundStyle(.common0)
                .focused($isFocused)
                .onAppear {
                    isFocused = true
                }
                .frame(maxWidth: .infinity)
                .frame(height: 64)
                .padding(.leading, 16)
                .background{
                    RoundedRectangle(cornerRadius: 14)
                        .fill(.neutral50)
                        .stroke(.neutral200)
                }
            
            statusText
                .frame(maxWidth: .infinity,alignment: .leading)
                .padding(.leading, 12)
                .padding(.top, 8)
        }
    }
    
    @ViewBuilder
    private var diglySection: some View {
        let selectedDigly = Digly.data[viewModel.selectedIndex]
        
        VStack(spacing: 0) {
            Text("문화생활을 누리는 \(viewModel.username)님은,")
                .fontStyle(.heading2)
                .foregroundStyle(.common0)
                .padding(.bottom, 32)
            
            VStack(spacing: 4) {
                Text(selectedDigly.description)
                    .fontStyle(.title3)
                    .foregroundStyle(.common0)
                
                HStack(spacing: 4) {
                    Text(selectedDigly.role)
                        .fontStyle(.title3)
                        .foregroundStyle(.common100)
                        .padding(4)
                        .background(selectedDigly.color)
                        .cornerRadius(8)
                    
                    Text("하시나요?")
                        .fontStyle(.title3)
                        .foregroundStyle(.common0)
                }
            }
            .padding(.bottom, 32)
            
            HStack(spacing: 6) {
                ForEach(Array(Digly.data.enumerated()), id: \.offset) { index, element in
                    Circle()
                        .fill(viewModel.selectedIndex == index ? Digly.data[index].color : .neutral300)
                        .frame(width: 8, height: 8)
                }
            }
            .padding(.bottom, 8)
            
            diglyTypeSelectSection
                .padding(.bottom, 24)
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
    }
    
    private var diglyTypeSelectSection: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<Digly.data.count, id: \.self) { index in
                        let digly = Digly.data[index]
                        Image("\(digly.diglyType.imageName)_avatar_box")
                            .shadow(color: .common0.opacity(0.2), radius: 8)
                        
                            .containerRelativeFrame(.horizontal, count: 1, spacing: 16)
                            .scrollTransition { content, phase in
                                content
                                    .opacity(phase.isIdentity ? 1.0 : 0.0)
                                    .scaleEffect(
                                        x: phase.isIdentity ? 1.0 : 0.3,
                                        y: phase.isIdentity ? 1.0 : 0.3
                                    )
                                    .offset(x: phase.isIdentity ? 0 : 50)
                            }
                            .id(index)
                    }
                }
                .scrollTargetLayout()
            }
            .contentMargins(16,for:.scrollContent)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: .init(get: {
                viewModel.selectedIndex
            }, set: { newPosition in
                if let newIndex = newPosition, newIndex >= 0, newIndex < Digly.data.count {
                    withAnimation {
                        viewModel.selectedIndex = newIndex
                    }
                }
            }))
            .overlay(
                HStack {
                    Image("arrow_left")
                        .padding(.leading, -24)
                        .onTapGesture {
                            viewModel.handleLeftArrowPress(proxy)
                        }
                    
                    Spacer()
                    
                    Image("arrow_right")
                        .padding(.trailing, -24)
                        .onTapGesture {
                            viewModel.handleRightArrowPress(proxy)
                        }
                }
            )
        }
    }
    
    @ViewBuilder
    private var statusText: some View {
        if viewModel.errorText.isEmpty {
            Text(viewModel.isUsernameValid ? "사용 가능한 아이디입니다." : "*2-7자의 한글, 영문, 특수기호, 이모티콘 사용 가능")
                .fontStyle(.label2)
                .foregroundStyle(viewModel.isUsernameValid ? .success :
                                    viewModel.username.isEmpty ? .neutral300 : .neutral700)
        } else {
            Text(viewModel.errorText)
                .fontStyle(.label2)
                .foregroundStyle(.error)
        }
    }
}

#Preview {
    NavigationStack {
        CreateAccountView(accessToken: "sample_token", refreshToken: "sample_refresh_token")
    }
}
