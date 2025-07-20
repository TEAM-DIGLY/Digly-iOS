import SwiftUI

struct AlarmRow: View {
    let alarm: Alarm
    
    var body: some View {
        VStack(spacing: 4){
            HStack(spacing: 16) {
                Image("\(alarm.diglyType.rawValue)_notification")
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(alarm.title)
                        .font(.label1)
                        .foregroundColor(.neutral15)
                    
                    Text(alarm.message)
                        .font(.label2)
                        .foregroundColor(.neutral25)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
            }
            
            Text(alarm.date.timeAgoString())
                .font(.caption1)
                .foregroundColor(.neutral45)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
