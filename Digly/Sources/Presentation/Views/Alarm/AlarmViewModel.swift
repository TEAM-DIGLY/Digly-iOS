import Foundation

class AlarmViewModel: ObservableObject {
    @Published var alarms: [Alarm] = []
    
    init() {
        fetchAlarms()
    }
    
    func fetchAlarms() {
        // Mock data based on the screenshot
        let calendar = Calendar.current
        let now = Date()
        
        let alarm1 = Alarm(diglyType: .analyst,
                               title: "드라큘라",
                               message: "티켓을 등록한 드라큘라의 관람일 3일 전이에요!",
                               date: now.addingTimeInterval(-60)) // 1분 전
        
        let alarm2Date = calendar.date(bySettingHour: 4, minute: 1, second: 0, of: now)!
        let alarm2 = Alarm(diglyType: .collector,
                               title: "드라큘라",
                               message: "티켓을 등록한 드라큘라의 관람일 3일 전이에요!",
                               date: alarm2Date) // (금) 오전 04:01, Assuming today is Friday for mockup
        
        var dateComponents = DateComponents()
        dateComponents.year = 2025
        dateComponents.month = 1
        dateComponents.day = 1
        dateComponents.hour = 22
        dateComponents.minute = 3
        let alarm3Date = calendar.date(from: dateComponents)!
        let alarm3 = Alarm(diglyType: .communicator,
                               title: "드라큘라",
                               message: "티켓을 등록한 드라큘라의 관람일 3일 전이에요!",
                               date: alarm3Date) // 2025.01.01 22:03
        
        self.alarms = [alarm1, alarm2, alarm3]
    }
} 