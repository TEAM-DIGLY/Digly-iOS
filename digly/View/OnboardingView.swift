//
//  OnboardingView.swift
//  digly
//
//  Created by 김 형석 on 10/14/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var isPopupPresented:Bool = true
    @State private var isTotalChecked:Bool = true
    
    var body: some View {
        ZStack {
            VStack(spacing:52){
                VStack(alignment:.leading,spacing:24){
                    Image("icon-text")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160)
                        .padding(.bottom,8)
                    
                    Text("문화생활의 여운\n일상에서 누릴 수 있는\n디깅라이프의 시작.")
                        .fontStyle(.title2Prime)
                        .foregroundStyle(.opacityCool55)
                    
                    Text("디글리에 오신\n당신을 환영합니다")
                        .fontStyle(.title2Prime)
                        .foregroundStyle(.accent)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
                
                HStack(spacing:12){
                    VStack{}.frame(width:75,height:75).background(.red)
                    VStack{}.frame(width:75,height:75).background(.red)
                    VStack{}.frame(width:75,height:75).background(.red)
                }
            }
            .padding(.horizontal,32)
            
            if isPopupPresented {
                ZStack{
                    Color.black.opacity(0.3)
                        .edgesIgnoringSafeArea(.all)
                    
                    VStack(spacing: 16) {
                        HStack (spacing:8) {
                            Image("icon")
                                .resizable()
                                .frame(width: 52,height: 52)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("digly")
                                    .fontStyle(.body1)
                                    .foregroundColor(.opacityCommon5)
                                
                                Text("문화생활의 여정, 일상에서 누리는 디깅라이프의 시작")
                                    .fontStyle(.caption2)
                                    .foregroundColor(.opacityCommon65)
                            }
                            Spacer()
                        }
                        
                        Divider()
                        
                        HStack(alignment: .top,spacing: 8) {
                            Button(action: {
                            }) {
                                Image(isTotalChecked ? "box_checked" : "box_unchecked")
                                    .contentTransition(.symbolEffect(.replace))
                            }
                            VStack(alignment: .leading,spacing:8){
                                Text("전체 동의하기")
                                    .fontStyle(.label2)
                                
                                Text("전체동의는 카카오 및 digly의 서비스 등의 이용약관에 동의합니다. 전체동의는 선택목적에 대한 동의를 포함하고 있으며, 선택목적에 대한 동의를 거부해도 서비스 이용이 가능합니다.")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }.frame(maxWidth: .infinity,alignment: .leading)
                        }
                        
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 12) {
                            Text("digly 서비스 동의")
                                .fontStyle(.caption2)
                                .foregroundStyle(.common0)
                                .padding(.leading,24)
                            
                            HStack (spacing:0) {
                                Image(systemName: "checkmark.circle.fill")
                                    .frame(width:24,height:16)
                                
                                Text("[필수] 이용약관 동의")
                                    .fontStyle(.caption2)
                                    .foregroundStyle(.common0)
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                
                                Spacer()
                                Text("보기")
                                    .fontStyle(.caption2)
                                    .foregroundColor(.opacityCommon65)
                                    .overlay(Rectangle()
                                        .fill(.opacityCommon65)
                                        .frame(height: 1),alignment: .bottom)
                            }
                            
                            HStack (spacing:0) {
                                Image(systemName: "checkmark.circle.fill")
                                    .frame(width:24,height:16)
                                
                                Text("[필수] 개인정보 수집 및 이용 동의")
                                    .fontStyle(.caption2)
                                    .foregroundStyle(.common0)
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                Spacer()
                                Text("보기")
                                    .fontStyle(.caption2)
                                    .foregroundColor(.opacityCommon65)
                                    .overlay(Rectangle()
                                        .fill(.opacityCommon65)
                                        .frame(height: 1),alignment: .bottom)
                            }
                            
                            HStack (alignment:.top, spacing:0) {
                                Image(systemName: "checkmark.circle")
                                    .frame(width:24,height:16)
                                
                                Text("[선택] digly의 광고와 마케팅 메시지를\n카카오톡으로 받습니다.")
                                    .fontStyle(.caption2)
                                    .foregroundStyle(.common0)
                                    .frame(maxWidth: .infinity,alignment: .leading)
                                Spacer()
                            }
                        }
                        
                        VStack(spacing:0){
                            Button(action: {}) {
                                Text("동의하고 계속하기")
                                    .fontStyle(.body2)
                                    .frame(maxWidth: .infinity)
                                    .padding(16)
                                    .background(.opacityCommon85)
                                    .foregroundColor(.common100)
                                    .cornerRadius(16)
                            }
                            
                            Button(action: {}) {
                                Text("취소")
                                    .fontStyle(.caption2)
                                    .foregroundColor(.opacityCommon65)
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
            }
        }
    }
}

#Preview {
    OnboardingView()
}
