import SwiftUI

struct HeartRateView: View {
    @StateObject private var viewModel = HeartRateViewModel()
    
    var body: some View {
        VStack {
            Text("Heart Rate: \(viewModel.currentHeartRate, specifier: "%.0f") bpm")
                .font(.title)
            
            Button(action: {
                viewModel.toggleHeartRateMonitoring()
            }) {
                Text(viewModel.isMonitoring ? "Stop Monitoring" : "Start Monitoring")
                    .padding()
                    .background(viewModel.isMonitoring ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Text(viewModel.message)
                .padding()
        }
        .onAppear {
            viewModel.startHeartRateMonitoring()
            viewModel.updateConnectionStatus()
        }
    }
}

#Preview {
    HeartRateView()
}
