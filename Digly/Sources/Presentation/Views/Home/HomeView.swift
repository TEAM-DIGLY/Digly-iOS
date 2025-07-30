import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var router: HomeRouter
    
    @StateObject var viewModel = HomeViewModel()
    @StateObject private var diglyManager = DiglyManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            HStack (spacing:4) {
                Text("\(AuthManager.shared.nickname)의")
                    .fontStyle(.headline1)
                    .foregroundStyle(.neutral5)
                
                Image(diglyManager.logoImageName)
                    .resizable()
                    .frame(width: 48,height:23)
                
                Spacer()
                
                Button(action:{
                    router.push(to: .alarmList)
                }) {
                    Image("alert")
                }
                
                Button(action:{
                    router.push(to: .myPage)
                }) {
                    Image(diglyManager.profileImageName)
                }
            }
            .frame(height:80)
            .padding(.horizontal, 36)
            
            ZStack{
                if viewModel.remainingDate > 4 {
                    Image(diglyManager.baseImageName)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                } else if viewModel.remainingDate > 3 {
                    RoundedRectangle(cornerRadius: 28)
                        .fill( .neutral95)
                        .stroke(.neutral75, lineWidth: 1.5)
                        .frame(width: 300, height: 300)
                } else if viewModel.remainingDate > 1 {
                    Image(diglyManager.liveBaseImageName)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                } else if viewModel.remainingDate > 0 {
                    
                } else {
                    Image("DDayBox")
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 300, height: 300)
                }
                
                VStack(spacing:24){
                    if viewModel.remainingDate<=4{
                        VStack(spacing:2){
                            Text("나의 0번째 문화생활")
                                .fontStyle(.body2)
                                .foregroundStyle(viewModel.remainingDate > 3 ?
                                    .neutral55 : viewModel.remainingDate > 0 ?
                                                 diglyManager.digly.lightColor : .opacityCool55)
                            
                            Text(viewModel.remainingDate != 0 ?
                                 "D-\(String(format: "%02d", viewModel.remainingDate))" :
                                    "D-DAY"
                            )
                            .fontStyle(.title1)
                                                         .foregroundStyle(viewModel.remainingDate > 3 ?
                                             diglyManager.digly.color :
                                                viewModel.remainingDate > 0 ? .common100 : .common0)
                        }
                        .padding(.top,40)
                    } else {
                        Spacer()
                    }
                    
                    Button(action: {}) {
                        Text(viewModel.remainingDate>4 ? "예매한 티켓 가져오기" : "티켓 타이틀" )
                            .fontStyle(.heading2)
                            .foregroundStyle(viewModel.remainingDate > 3 ? .common0 : .common100)
                            .frame(width:240,height:60)
                            .background(RoundedRectangle(cornerRadius: 20)
                                .fill(backgroundColorForRemainingDays(viewModel.remainingDate))
                                .opacity(opacityForRemainingDays(viewModel.remainingDate))
                                .shadow(color: Color("000000")
                                    .opacity(viewModel.remainingDate > 4 ? 0.15 : 0.0), radius: 4)
                            )
                    }
                    
                    HStack(alignment: .bottom) {
                        Image("liveplay")
                        Spacer()
                        HStack(alignment:.center, spacing:4){
                            Image("secure")
                            Text("사용 가이드")
                                .fontStyle(.label1)
                                .foregroundStyle(.neutral15)
                            
                            Image("chevron_right")
                                .foregroundStyle(.neutral45)
                        }
                    }
                    .padding(.horizontal,20)
                    .padding(.bottom,24)
                }
            }
            .frame(width:300,height:300)
            .padding(.bottom, 16)
            
            HStack(spacing: 16) {
                FeatureButton(icon: "chat", title: "실시간 채팅",isActive:viewModel.remainingDate==0)
                FeatureButton(icon: "memo", title: "오프라인 메모",isActive:viewModel.remainingDate==0)
            }
            .padding(.horizontal, 45)
            .padding(.bottom, 16)
            
            HStack(alignment: .bottom) {
                // My Notes
                VStack{
                    Image(diglyManager.avatarImageName)
                        .padding(.bottom,-28)
                    
                    VStack (alignment:.leading) {
                        Text("내가 작성한 노트")
                            .fontStyle(.label1)
                            .foregroundStyle(.neutral15)
                        
                        HStack{
                            Text("18")
                                .fontStyle(.headline2)
                                .foregroundStyle(.neutral15)
                            Spacer()
                            
                            Image("chevron_right")
                                .foregroundStyle(.neutral45)
                        }
                    }
                    .frame(width: 120)
                    .padding(14)
                    .background(.opacityCool95)
                    .cornerRadius(24)
                }
                
                Spacer()
                
                VStack {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.neutral85)
                            .frame(width: 112, height: 112)
                            .foregroundColor(.clear)
                            .shadow(color: Color("000000")
                                .opacity(0.15), radius: 4
                            )
                            .rotationEffect(.degrees(20))
                            .offset(x: 12, y: -88)
                        
                        RoundedRectangle(cornerRadius: 24)
                            .fill(.neutral85)
                            .frame(width: 112, height: 112)
                            .foregroundColor(.clear)
                            .shadow(color: Color("000000")
                                .opacity(0.15), radius: 4
                            )
                            .rotationEffect(.degrees(-20))
                            .offset(x: -16, y: -64)
                        
                        Image("plus")
                            .background(
                                RoundedRectangle(cornerRadius: 24)
                                    .fill(.neutral85)
                                    .frame(width: 130, height: 130)
                                    .foregroundColor(.clear)
                                    .shadow(color: Color("000000")
                                        .opacity(0.15), radius: 4)
                            )
                            .onTapGesture {
                                print("add")
                            }
                    }
                }
            }
            .padding(.horizontal, 45)
            .padding(.bottom, 24)
            
            Spacer()
        }
    }
    
    private func backgroundColorForRemainingDays(_ days: Int) -> Color {
        switch days {
        case 0...3:
            return .opacityCool65
        case 4:
            return diglyManager.digly.lightColor
        default:
            return .neutral85
        }
    }
    private func opacityForRemainingDays(_ days:Int) -> Double {
        switch days {
        case 0...3:
            return 0.25
        case 4:
            return 0.5
        default:
            return 0.8
        }
    }
}

struct FeatureButton: View {
    let icon: String
    let title: String
    let isActive: Bool
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 6) {
                Image(icon)
                    .renderingMode(.template)
                    .foregroundStyle(isActive ? .neutral15 : .neutral55)
                Text(title)
                    .fontStyle(.label1)
                    .foregroundStyle(isActive ? .neutral35 : .neutral55)
            }
            .frame(maxWidth: .infinity,alignment:.leading)
            .padding(12)
            .background{
                RoundedRectangle(cornerRadius: 24)
                    .fill(isActive ? .common100 : .neutral84)
                    .stroke(isActive ? .neutral75 : .clear)
            }
        }
    }
}
