import SwiftUI

struct AlarmRow: View {
    let alarm: Alarm
    
    var body: some View {
        VStack(spacing: 4){
            HStack(spacing: 16) {
                Image("\(AuthManager.shared.diglyType.imageName)_notification")
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(alarm.title)
                        .font(.label1)
                        .foregroundColor(.neutral800)
                    
                    Text(alarm.content)
                        .font(.label2)
                        .foregroundColor(.neutral700)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity,alignment: .leading)
            }
            
            Text(alarm.createdAt.timeAgoString())
                .font(.caption1)
                .foregroundColor(.neutral500)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}
