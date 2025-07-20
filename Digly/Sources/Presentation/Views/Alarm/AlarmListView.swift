import SwiftUI

struct AlarmListView: View {
    @StateObject private var viewModel = AlarmViewModel()

    var body: some View {
        VStack(spacing: 0) {
            BackNavWithTitle(title:"알림함")
                .padding(.horizontal, 16)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    Spacer().frame(height: 24)
                    ForEach(viewModel.alarms) { alarm in
                        AlarmRow(alarm: alarm)
                            .padding(.horizontal, 12)
                        
                        Divider()
                            .padding(.vertical, 16)
                    }
                    .padding(.horizontal, 24)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    AlarmListView()
}
