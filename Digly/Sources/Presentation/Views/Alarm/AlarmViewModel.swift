import Foundation

class AlarmViewModel: ObservableObject {
    @Published var alarms: [Alarm] = []
    
    init() {
        fetchAlarms()
    }
    
    func fetchAlarms() {}
} 
