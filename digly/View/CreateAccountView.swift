//
//  CreateAccountView.swift
//  digly
//
//  Created by Neoself on 11/3/24.
//

import SwiftUI

struct CreateAccountView: View {
    @StateObject var viewModel = CreateAccoutViewModel()
    @FocusState private var isUsernameFocused:Bool
    
    @State private var eyeXOffset: CGFloat = 0
    @State private var eyeYOffset: CGFloat = 0
    
    @State private var eyeSize: CGFloat = 8
    
    var body: some View {
        NavigationStack{
            VStack {
                ZStack {
                    Circle()
                        .fill(.neutral5)
                        .frame(width: 62, height: 62)
                    
                    HStack(spacing: 6) {
                        Circle()
                            .fill(.common100)
                            .frame(width: eyeSize, height: eyeSize)
                        
                        Circle()
                            .fill(.common100)
                            .frame(width: eyeSize, height: eyeSize)
                    }
                    .offset(x: eyeXOffset)
                    .offset(y: 6 + eyeYOffset)
                }
                .padding(.bottom,64)
                
                if !viewModel.isSelectingDigly {
                    usernameSection(viewModel:viewModel)
                } else {
                    diglySection(viewModel: viewModel)
                }
                Spacer()
            }
            .padding(.vertical,80)
            .padding(.horizontal,32)
            .background(.common100)
            .navigationBarBackButtonHidden()
            .toolbar(.hidden)
            .onTapGesture { isUsernameFocused = false }
            
            .onChange(of: isUsernameFocused){
                if !isUsernameFocused {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.longEaseInOut){
                            eyeXOffset = 0
                            eyeYOffset = 0
                        } }
                } else {
                    withAnimation(.spring(response:0.2,dampingFraction: 0.5)) { eyeSize = 14 }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.longEaseInOut){
                            eyeSize = 8
                            eyeYOffset = 8
                        } }
                }
            }
            .onChange(of: viewModel.username) {
                let progress = CGFloat($1.count) / 15.0
                withAnimation(.spring(response: 0.7, dampingFraction: 0.6)){
                    eyeXOffset = min(10,-10 + (progress * 20))
                }
            }
        }
    }
    
    @ViewBuilder
    private func usernameSection(viewModel:CreateAccoutViewModel) -> some View {
        VStack(spacing: 16) {
            Text("만나서 반가워요!")
                .fontStyle(.title3)
                .foregroundStyle(.neutral5)
            
            Text("앞으로 당신을\n어떻게 부를까요?")
                .fontStyle(.title3)
                .foregroundStyle(.neutral5)
                .multilineTextAlignment(.center)
        }
        .padding(.bottom,24)
        
        HStack(spacing: 0) {
            TextField("", text: $viewModel.username, prompt: Text("이름").foregroundColor(.neutral65))
                .fontStyle(.title2)
                .foregroundStyle(.common0)
                .focused($isUsernameFocused)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity)
            
            Button(action: {
                viewModel.handleSubmit()
            }) {
                Text(viewModel.isUsernameValid ? "완료" : "다음")
                    .fontStyle(.title3)
                    .transition(.opacity.animation(.easeInOut))
                    .foregroundStyle(viewModel.username.isEmpty || !viewModel.errorText.isEmpty ? .opacityCommon75 : .opacityCommon25)
            }
            .frame(width:72)
            .disabled(viewModel.username.isEmpty || !viewModel.errorText.isEmpty)
        }
        .frame(height:64)
        .padding(.leading, 16)
        .background{
            RoundedRectangle(cornerRadius: 14)
                .fill(.neutral95)
                .stroke(.neutral75)
        }
        
        statusText()
            .frame(maxWidth: .infinity,alignment: .leading)
            .padding(.leading,12)
        
    }
    
    @ViewBuilder
    private func diglySection(viewModel:CreateAccoutViewModel) -> some View {
        let selectedDigly = DiglyType.data[viewModel.selectedIndex]
        
        VStack {
            Text("문화생활을 누리는 \(viewModel.username)님은,")
                .fontStyle(.heading2)
                .foregroundStyle(.common0)
                .padding(.bottom,32)
            
            VStack(spacing: 4) {
                Text(selectedDigly.description)
                    .fontStyle(.title3)
                    .foregroundStyle(.common0)
                
                HStack{
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
        }
        .padding(.bottom, 20)
        
        HStack(spacing: 6) {
            ForEach(Array(DiglyType.data.enumerated()), id: \.offset) { index, element in
                Circle()
                    .fill(viewModel.selectedIndex == index ? DiglyType.data[index].color : .neutral65)
                    .frame(width: 8, height: 8)
            }
        }
        
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<DiglyType.data.count, id: \.self) { index in
                        let digly = DiglyType.data[index]
                        Image("\(digly.name)Digly")
                            .shadow(color: Color(hex:"000000").opacity(0.2), radius: 8)
                        
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
                    if let newIndex = newPosition, newIndex >= 0, newIndex < DiglyType.data.count {
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
                    // .opacity(viewModel.selectedIndex == 0 ? 0.2 : 1.0)
                    Spacer()
                    Image("arrow_right")
                        .padding(.trailing, -24)
                        .onTapGesture {
                            viewModel.handleRightArrowPress(proxy)
                        }
                    //.opacity(viewModel.selectedIndex == 0 ? 0.2 : 1.0)
                }
            )
        }
        
        NavigationLink(destination: OnboardingAnimationView(viewModel:viewModel)) {
            Text("\(DiglyType.data[viewModel.selectedIndex].role)하는 디글러 선택하기")
                .fontStyle(.body2)
                .foregroundStyle(.common100)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(.neutral5)
                .cornerRadius(12)
        }
        .padding(.horizontal, 24)
        .padding(.top, 32)
    }
    
    
    @ViewBuilder
    private func statusText() -> some View {
        if viewModel.errorText.isEmpty {
            Text(viewModel.isUsernameValid ? "사용 가능한 아이디입니다." : "*2-7자의 한글, 영문, 특수기호, 이모티콘 사용 가능")
                .fontStyle(.label2)
                .foregroundStyle(viewModel.isUsernameValid ? .success :
                                    viewModel.username.isEmpty ? .neutral65 : .neutral25)
        } else {
            Text(viewModel.errorText)
                .fontStyle(.label2)
                .foregroundStyle(.error)
        }
    }
}

#Preview {
    NavigationStack {
        CreateAccountView()
    }
}
