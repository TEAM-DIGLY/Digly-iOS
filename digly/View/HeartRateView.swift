import SwiftUI

struct HeartRateView: View {
    @StateObject private var viewModel = HeartRateViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Heart Rate Monitor")
                .font(.largeTitle)
            
            Text("\(Int(viewModel.currentHeartRate)) BPM")
                .font(.system(size: 60, weight: .bold, design: .rounded))
                .foregroundColor(.red)
            
            Text("Connection Status:")
                .font(.headline)
            Text(viewModel.connectionStatus)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .onAppear {
            viewModel.updateConnectionStatus()
        }
    }
}

#Preview {
    HeartRateView()
}
