import SwiftUI

struct TicketNoteCardView: View {
    let ticketWithNotes: TicketWithNotes
    
    @Binding var isExpanded: Bool
    
    private var ticketGradient: LinearGradient {
        let colors = ticketWithNotes.ticket.emotions.map { $0.color }
        if colors.isEmpty {
            return LinearGradient(colors: [.neutral800, .neutral700], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else if colors.count == 1 {
            return LinearGradient(colors: [colors[0].opacity(0.2), colors[0].opacity(0.1)], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else {
            return LinearGradient(colors: colors.map{ $0.opacity(0.2) }, startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            upperSection
            
            if isExpanded, !ticketWithNotes.notes.isEmpty  {
                VStack(spacing: 16) {
                    ForEach(ticketWithNotes.notes) { note in
                        noteSection(note)
                    }
                }
                .padding(.top, 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            UnevenRoundedRectangle(
                topLeadingRadius: 16,
                bottomLeadingRadius: 16,
                bottomTrailingRadius: isExpanded ? 0 : 56,
                topTrailingRadius: isExpanded ? 0 : 16
            )
            .fill(isExpanded ? ticketGradient : LinearGradient(
                colors: [.opacityWhite50, .opacityWhite50],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            )
        )
        .onTapGesture {
            isExpanded.toggle()
        }
        .padding(.leading, 24)
        .padding(.trailing, isExpanded ? 0 : 24)
    }
    
    private var upperSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text(ticketWithNotes.ticket.name)
                    .fontStyle(.body2)
                    .foregroundStyle(.common100)
                    .multilineTextAlignment(.leading)
                
                Spacer()
                
                Button(action: { isExpanded.toggle() }) {
                    Image("chevron_down")
                        .renderingMode(.template)
                        .foregroundColor(.opacityWhite700)
                        .rotationEffect(Angle(degrees: isExpanded ? 180 : 0))
                        .frame(width: 24, height: 24)
                }
                .padding(.trailing, isExpanded ? 40 : 16)
            }
            
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image("digging_note")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(.neutral400)
                        .frame(width: 12, height: 12)
                    
                    
                    Text("\(ticketWithNotes.noteCount)개의 노트")
                        .fontStyle(.caption1)
                        .foregroundStyle(.opacityWhite850)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.opacityWhite100, lineWidth: 1)
                )
                
                if !ticketWithNotes.formattedLastNoteDate.isEmpty, !isExpanded {
                    HStack(spacing: 4) {
                        Text("최근 작성일")
                            .fontStyle(.caption1)
                            .foregroundStyle(.common100.opacity(0.7))
                        
                        Circle()
                            .fill(.common100.opacity(0.7))
                            .frame(width: 2, height: 2)
                        
                        Text(ticketWithNotes.formattedLastNoteDate)
                            .fontStyle(.caption1)
                            .foregroundStyle(.common100.opacity(0.7))
                    }
                }
                
                Spacer()
            }
        }
    }
    
    private func noteSection(_ note: Note) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(note.updatedAt.timeAgoString())
                .fontStyle(.caption1)
                .foregroundStyle(.neutral400)
            
//            Text(note.content)
//                .fontStyle(.label2)
//                .foregroundStyle(.neutral100)
//                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(.opacityWhite50, in: RoundedRectangle(cornerRadius: 16))
    }
}
