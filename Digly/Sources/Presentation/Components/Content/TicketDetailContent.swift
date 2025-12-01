import SwiftUI

struct TicketDetailContent: View {
    @AppStorage(UserDefaultKeys.nickname) private var nicknameUD: String = ""
    let ticket: Ticket
    let onTapAddEmotion: () -> Void
    
    var body: some View {
        VStack(spacing: 0){
            Text(ticket.name)
                .fontStyle(.heading1)
                .foregroundStyle(.common100)
                .padding(.bottom, 12)
            
            ticketCard
                .padding(.bottom, 40)
            basicInfoSection(ticket: ticket)
            
            if let notes = ticket.notes, !notes.isEmpty {
                notesSection(notes: notes)
                    .padding(.top, 40)
            }
            
            Spacer().frame(height: 120)
        }
    }
    
    private var ticketCard: some View {
        ZStack(alignment: .top) {
            Image("ticket-base-big")
            
            EmotionBackgroundGradient(selectedEmotions: ticket.emotions, size: 180, opacity: 0.26)
                .offset(y: -40)
                .animation(.spring(duration: 1.4), value: ticket.emotions)
            
            VStack(alignment: .center, spacing: 0) {
                Text("@\(nicknameUD.isEmpty ? "username" : nicknameUD)")
                    .fontStyle(.body2)
                    .foregroundStyle(.opacityWhite300)
                    .padding(.top, 24)
                
                Spacer()
                
                if ticket.emotions.isEmpty {
                    Text("관람 중에 느낀\n나만의 감정을 남겨볼까요?")
                        .fontStyle(.label2)
                        .foregroundStyle(.opacityWhite700)
                        .multilineTextAlignment(.center)
                    
                    Image("chevron_down_sm")
                        .padding(.top, -12)
                }
                
                Rectangle()
                    .fill(.opacityWhite100)
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
                    .padding(.horizontal, 32)
                
                Group {
                    if !ticket.emotions.isEmpty {
                        HStack(spacing: 8) {
                            ForEach(ticket.emotions.prefix(2), id: \.self) { emotion in
                                Text("#\(emotion.rawValue)")
                                    .fontStyle(.body1)
                                    .foregroundStyle(emotion.color)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                            }
                        }
                    } else {
                        Text("감정 남기러 가기")
                            .fontStyle(.headline2)
                            .foregroundStyle(.opacityWhite850)
                            .onTapGesture {
                                onTapAddEmotion()
                            }
                    }
                }
                .frame(height: 76, alignment: .center)
            }
            .padding(24)
        }
        .frame(width: 279, height: 376)
        .padding(.horizontal, 48)
    }
    
    
    private func basicInfoSection(ticket: Ticket) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("기본정보")
                .fontStyle(.body1)
                .foregroundStyle(.opacityWhite800)
                .padding(.leading, 12)
            
            VStack(spacing: 16) {
                infoRow(title: "관람일", content: ticket.time.toKoreanDateString(), subtitle: "#\(ticket.count)번째 관람")
                
                infoRow(title: "장소", content: ticket.place)
                
                if let seatNumber = ticket.seatNumber {
                    infoRow(title: "좌석", content: seatNumber)
                }
                
                if let price = ticket.price {
                    infoRow(title: "가격", content: "\(price.formatted())원")
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(.common0, in: UnevenRoundedRectangle(
                topLeadingRadius: 10,
                bottomLeadingRadius: 10,
                bottomTrailingRadius: 24,
                topTrailingRadius: 24
            ))
            .overlay {
                UnevenRoundedRectangle(
                    topLeadingRadius: 10,
                    bottomLeadingRadius: 10,
                    bottomTrailingRadius: 24,
                    topTrailingRadius: 24
                )
                .stroke(.opacityWhite50, lineWidth: 1)
            }
        }
        .padding(.horizontal, 24)
    }
    
    private func notesSection(notes: [Note]) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 0) {
                Text("작성한 노트")
                    .fontStyle(.body1)
                    .foregroundStyle(.opacityWhite800)
                
                Text(" \(notes.count)")
                    .fontStyle(.body1)
                    .foregroundStyle(.opacityWhite800)
                
                Spacer()
            }
            .padding(.leading, 18)
            
            VStack(spacing: 16) {
                ForEach(notes) { note in
                    DGNoteCard(note: note)
                }
            }
        }
        .padding(.horizontal, 24)
    }
    
    private func infoRow(title: String, content: String, subtitle: String? = nil) -> some View {
        HStack(alignment: .top, spacing: 0) {
            Text(title)
                .fontStyle(.body2)
                .foregroundStyle(.opacityWhite500)
                .frame(width: 66, alignment: .leading)
            
            VStack(alignment: .leading, spacing: 6) {
                Text(content)
                    .fontStyle(.body2)
                    .foregroundStyle(.common100)
                
                if let subtitle = subtitle {
                    Text(subtitle)
                        .fontStyle(.body2)
                        .foregroundStyle(.common100)
                }
            }
            
            Spacer()
        }
    }
}
