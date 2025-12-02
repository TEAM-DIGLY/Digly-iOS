import SwiftUI

struct DGNoteCard: View {
    let note: Note
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 0) {
                /// 단일 무형식 답변
                Text(note.updatedAt.timeAgoString())
                    .font(.caption1)
                    .foregroundStyle(.neutral500)
                    .padding(.bottom, 12)
                
                if let firstNote = note.contents.first,
                   firstNote.question.isEmpty {
                    Text(firstNote.answer)
                        .font(.label2)
                        .foregroundStyle(.neutral200)
                        .lineLimit(3)
                } else {
                    ForEach(Array(note.contents.enumerated()), id: \.offset) { index, content in
                        if index != 0 {
                            Divider().background(.grayscale600)
                                .padding(.vertical, 6)
                        }
                        
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Q. \(content.question)")
                                .font(.caption2)
                                .foregroundStyle(.neutral400)
                            
                            Text(content.answer)
                                .font(.label2)
                                .foregroundStyle(.neutral200)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(.opacityWhite50, in: RoundedRectangle(cornerRadius: 16))
        }
    }
}
