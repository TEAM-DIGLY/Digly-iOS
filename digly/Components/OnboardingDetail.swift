//
//  OnboardingPopup.swift
//  digly
//
//  Created by Neoself on 11/2/24.
//
import SwiftUI

struct OnboardingDetail: View {
    @ObservedObject var viewModel : OnboardingViewModel
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack(spacing: 16) {
            HStack (spacing:8) {
                Image("icon")
                    .resizable()
                    .frame(width: 52,height: 52)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("digly")
                        .fontStyle(.body1)
                        .foregroundStyle(.opacityCommon5)
                    
                    Text("문화생활의 여정, 일상에서 누리는 디깅라이프의 시작")
                        .fontStyle(.caption2)
                        .foregroundStyle(.opacityCommon65)
                }
                Spacer()
            }
            
            Divider()
            
            VStack(alignment: .leading, spacing: 8) {
                Button(action: {
                    viewModel.toggleAllChecks()
                }) {
                    HStack{
                        Image(viewModel.isAllChecked ? "checkBox_filled" : "checkBox")
                            .resizable()
                            .frame(width:18,height:18)
                        
                        Text("전체 동의하기")
                            .fontStyle(.label2)
                    }
                }
                
                Text("전체동의는 카카오 및 digly의 서비스 등의 이용약관에 동의합니다. 전체동의는 선택목적에 대한 동의를 포함하고 있으며, 선택목적에 대한 동의를 거부해도 서비스 이용이 가능합니다.")
                    .font(.caption)
                    .foregroundStyle(.opacityCommon65)
                    .padding(.leading,26)
            }
            .frame(maxWidth: .infinity,alignment: .leading)
            
            
            Divider()
            
            VStack(alignment: .leading, spacing: 12) {
                checkItem(isChecked: $viewModel.isFirstChecked, description: "[필수] 이용약관 동의") {
                    print("onFirstPress")
                }
                checkItem(isChecked: $viewModel.isSecondChecked, description:"[필수] 개인정보 수집 및 이용 동의") {
                    print("onSecondPress")
                }
                checkItem(isChecked: $viewModel.isThirdChecked, isOptional:true, description: "[선택] digly의 광고와 마케팅 메시지를 카카오톡으로 받습니다.") {
                    print("onThirdPress")
                }
            }
            
            VStack(spacing:0){
                NavigationLink(destination: CreateAccountView()){
                    Text("동의하고 계속하기")
                        .fontStyle(.body2)
                        .frame(maxWidth: .infinity)
                        .padding(16)
                        .background(viewModel.isContinueButtonDisabled ? .opacityCommon85 : .opacityCool0)
                        .foregroundStyle(.common100)
                        .cornerRadius(16)
                }
                .disabled(viewModel.isContinueButtonDisabled)
                
                Button(action: { isShowing=false }) {
                    Text("취소")
                        .fontStyle(.caption2)
                        .foregroundStyle(.opacityCommon65)
                        .overlay(Rectangle()
                            .fill(.opacityCommon65)
                            .frame(height: 1),alignment: .bottom)
                        .frame(maxHeight:30,alignment: .bottom)
                }
            }.padding(.top,16)
        }
        .padding(24)
        .background(.common100)
        .cornerRadius(24)
        .shadow(radius: 10)
        .padding(.horizontal, 40)
    }
    
    @ViewBuilder
    private func checkItem(isChecked: Binding<Bool>, isOptional:Bool = false, description: String, onPress: @escaping () -> Void) -> some View {
        HStack(spacing: 0) {
            HStack(spacing:8) {
                Image("check")
                    .renderingMode(.template)
                    .foregroundStyle(isChecked.wrappedValue ? .neutral5 : .opacityCommon65)
                
                Text(description)
                    .fontStyle(.caption2)
                    .foregroundStyle(isChecked.wrappedValue ? .opacityCommon15 : isOptional ? .opacityCommon85 : .opacityCommon65)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .onTapGesture {
                isChecked.wrappedValue.toggle()
            }
            Spacer()
            
            Text("보기")
                .fontStyle(.caption2)
                .foregroundStyle(.opacityCommon65)
                .overlay(Rectangle()
                    .fill(.opacityCommon65)
                    .frame(height: 1), alignment: .bottom)
                .padding(.horizontal,4)
                .onTapGesture(perform: onPress)
        }
    }
}


