//import SwiftUI
//
//struct CustomPopup: View {
//    let hidePopup: () -> Void
//    let popupData: PopupData
//    
//    var body: some View {
//        VStack(spacing: 0) {
//            VStack(spacing:6){
//                Text(popupData.type.title)
//                    .font(._headline2)
//                    .foregroundColor(.opacity90)
//                    .padding(.top,4)
//                
//                Text(popupData.type.description)
//                    .font(._body3)
//                    .foregroundColor(.opacity50)
//                    .multilineTextAlignment(.center)
//            }
//            .padding(.vertical,12)
//            
//            if popupData.type.isMandatory {
//                Button(action: {
//                    popupData.action()
//                }) {
//                    Text(popupData.type.primaryButtonText)
//                        .frame(maxWidth: .infinity)
//                        .font(._body1)
//                        .padding(.vertical, 9)
//                        .foregroundStyle(.opacity00)
//                        .background(RoundedRectangle(cornerRadius: 8)
//                            .fill(.blue30)
//                        )
//                }
//                .padding(8)
//            } else{
//                if popupData.type.isBtnHorizontal {
//                    horizontalButtonLayer
//                } else {
//                    verticalButtonLayer
//                }
//            }
//        }
//        .padding(.horizontal,12)
//        .padding(.vertical,8)
//        .background(RoundedRectangle(cornerRadius:20)
//            .fill(.opacity00)
//        )
//        .padding(.horizontal, 44)
//    }
//    
//    
//    // MARK: - 하단 버튼 레이어
//    private var verticalButtonLayer: some View {
//        VStack(spacing: 4) {
//            Button(action: {
//                popupData.action()
//                hidePopup()
//            }) {
//                Text(popupData.type.primaryButtonText)
//                    .frame(maxWidth: .infinity)
//                    .font(._body1)
//                    .padding(.vertical, 9)
//                    .foregroundStyle(.opacity00)
//                    .background(RoundedRectangle(cornerRadius: 8)
//                        .fill(.blue30)
//                    )
//            }
//            
//            Button(action: {
//                hidePopup()
//            }) {
//                Text("닫기")
//                    .font(._body1)
//                    .foregroundStyle(.opacity60)
//            }
//            .padding(8)
//        }
//    }
//    
//    private var horizontalButtonLayer: some View {
//        HStack(spacing: 8) {
//            Button(action: {
//                hidePopup()
//            }) {
//                Text(popupData.type.secondaryButtonText)
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 13)
//                    .background(.opacity20)
//                    .foregroundColor(.opacity60)
//                    .cornerRadius(8)
//            }
//            
//            Button(action: {
//                popupData.action()
//                hidePopup()
//            }) {
//                Text(popupData.type.primaryButtonText)
//                    .frame(maxWidth: .infinity)
//                    .padding(.vertical, 13)
//                    .background(.blue30)
//                    .foregroundStyle(.opacity00)
//                    .cornerRadius(8)
//            }
//        }
//        .font(._body1)
//    }
//}
