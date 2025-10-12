import SwiftUI

struct TicketNoteCardView: View {
    let ticketWithNotes: TicketWithNotes
    
    @Binding var isExpanded: Bool
    
    private var ticketGradient: LinearGradient {
        let colors = ticketWithNotes.ticket.color.map { $0.color }
        if colors.isEmpty {
            return LinearGradient(colors: [.neutral15, .neutral25], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else if colors.count == 1 {
            return LinearGradient(colors: [colors[0], colors[0].opacity(0.8)], startPoint: .topLeading, endPoint: .bottomTrailing)
        } else {
            return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            upperSection
            
            if isExpanded {
                expandedView
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 24)
        .background(
            Group {
                UnevenRoundedRectangle(
                     topLeadingRadius: 16,
                     bottomLeadingRadius: 16,
                     bottomTrailingRadius: isExpanded ? 16 : 56,
                     topTrailingRadius: isExpanded ? 0 : 16
                     )
                     .fill(ticketGradient)
            }
        )
        .onTapGesture {
            isExpanded.toggle()
        }
        .padding(.leading, 24)
        .padding(.trailing, isExpanded ? 0 : 24)
    }
    
    private var expandedView: some View {
        VStack(spacing: 0) {
            if !ticketWithNotes.notes.isEmpty {
                VStack(spacing: 16) {
                    ForEach(ticketWithNotes.notes) { note in
                        NoteContentItem(note: note)
                    }
                }
                .padding(.top, 20)
            }
        }
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
                        .foregroundColor(.opacityWhite25)
                        .rotationEffect(Angle(degrees: isExpanded ? 180 : 0))
                        .frame(width: 24, height: 24)
                }
            }
            
            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Image("digging_note")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(.neutral55)
                        .frame(width: 12, height: 12)
                    
                    
                    Text("\(ticketWithNotes.noteCount)개의 노트")
                        .fontStyle(.caption1)
                        .foregroundStyle(.opacityWhite5)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.opacityWhite85, lineWidth: 1)
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
}
