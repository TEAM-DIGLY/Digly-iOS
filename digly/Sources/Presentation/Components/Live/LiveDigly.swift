import SwiftUI

struct LiveDigly : View {
    var isSurprised: Bool = false
    var readingValue: String = ""
    var onStareUp: Bool = false
    
    @State private var eyeXOffset: CGFloat = 0
    @State private var eyeYOffset: CGFloat = 0
    @State private var eyeSize: CGFloat = 8
    
    var body : some View{
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
          
        .onChange(of: isSurprised){
            if !isSurprised {
                // Digly 섹션으로 넘어가면서 TextField focus 해제되는 경우
                if onStareUp {
                    withAnimation(.mediumEaseInOut){
                        eyeXOffset = 0
                        eyeYOffset = -12
                    }
                } else { // username 변경 세션에서 TextField focus 해제되는 경우
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        withAnimation(.longEaseInOut){
                            eyeXOffset = 0
                            eyeYOffset = 0
                        } }
                }
            } else {
                //TODO: FOCUS 상태가 해제되지 않은 상태에서 바로 디글리 선택 세션으로 이동할때, onStareup 애니메이션 적용 안되는 이슈 수정
                // TextField focus 상태일 경우, 눈 위치 아래로 이동
                withAnimation(.spring(response:0.2,dampingFraction: 0.5)) { eyeSize = 14 }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation(.longEaseInOut){
                        eyeSize = 8
                        eyeYOffset = 8
                    } }
            }
        }
        
        .onChange(of: readingValue) {
            // TextField 내부 글자 개수에 따라 눈동자 XOffset 실시간 변경
            let progress = CGFloat($1.count) / 15.0
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6)){
                eyeXOffset = min(10,-10 + (progress * 20))
            }
        }
    }
}
