import SwiftUI

struct DiggingNoteView: View {
    @State private var expandedNoteId: String? = "1"
    @State private var notes: [NoteItem] = [
        NoteItem(id: "1", title: "캣츠 내한공연 50주년", date: "2025.03.03", noteCount: 3, content: [
            "나는 이렇게 생각해서 이렇게 만들었는데 또 이게 아닌 것 같고 어디서 잘 모르겠어.",
            "나는 이렇게 생각해서 이렇게 만들었는데 또 이게 아닌 것 같고 어디서 잘 모르겠어.",
            "나는 이렇게 생각해서 이렇게 만들었는데 또 이게 아닌 것 같고 어디서 잘 모르겠어."
        ]),
        NoteItem(id: "2", title: "캣츠 내한공연 50주년", date: "2025.03.03", noteCount: 3, content: [])
    ]
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 40){
                header
                
                VStack(spacing: 16) {
                    ForEach(notes, id: \.id) { note in
                        NoteCardView(
                            note: note,
                            isExpanded: expandedNoteId == note.id,
                            toggleExpand: {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    if expandedNoteId == note.id {
                                        expandedNoteId = nil
                                    } else {
                                        expandedNoteId = note.id
                                    }
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal, 24)
            }
        }
    }
    
    private var header: some View {
            HStack {
                Text("\(KeychainManager.shared.getUsername() ?? "Username")'s\ndigging note")
                    .fontStyle(.title2)
                    .foregroundStyle(.common100)
                
                Spacer()
                
                Button(action: {
                }) {
                    VStack(spacing: 4) {
                        Image("plus")
                            .resizable()
                            .frame(width: 16, height: 16)
                        
                        Text("노트 추가")
                            .font(.label2)
                            .foregroundColor(.opacity15)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 72)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.clear)
                            .stroke(.opacity75, lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
    }
}

struct NoteItem: Identifiable {
    let id: String
    let title: String
    let date: String
    let noteCount: Int
    let content: [String]
}

struct NoteCardView: View {
    let note: NoteItem
    let isExpanded: Bool
    let toggleExpand: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            Button(action: toggleExpand) {
                HStack {
                    Text(note.title)
                        .fontStyle(.body1)
                        .foregroundStyle(.common100)
                    
                    Spacer()
                    
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.common100)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: isExpanded ? 12 : 12)
                        .fill(.neutral15)
                )
            }
            
            if isExpanded {
                VStack(spacing: 8) {
                    HStack(spacing: 4) {
                        Image("diggingNote")
                            .resizable()
                            .frame(width: 12, height: 12)
                        
                        Text("\(note.noteCount)개의 노트")
                            .fontStyle(.caption1)
                            .foregroundStyle(.neutral55)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 8)
                    .overlay(RoundedRectangle(cornerRadius: 8)
                        .stroke(.opacity85, lineWidth: 1)
                    )
                    
                    VStack(spacing: 8) {
                        ForEach(0..<note.content.count, id: \.self) { index in
                            NoteContentItem(content: note.content[index])
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
//                .background(
//                    RoundedRectangle(cornerRadius: 12)
//                        .fill(.)
//                )
            }
            
            // Footer (collapsed view in second card)
            if !isExpanded {
                HStack {
                    Image(systemName: "note.text")
                        .foregroundColor(.neutral55)
                    
                    Text("\(note.noteCount)개의 노트")
                        .fontStyle(.caption1)
                        .foregroundStyle(.neutral55)
                    
                    Spacer()
                    
                    Text("최근 작성일 · \(note.date)")
                        .fontStyle(.caption1)
                        .foregroundStyle(.neutral55)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.common100)
                        .stroke(.neutral75, lineWidth: 1)
                )
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.clear)
                .shadow(color: .opacity15, radius: 4, x: 0, y: 2)
        )
    }
}

struct NoteContentItem: View {
    let content: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Text("어제")
                .fontStyle(.caption1)
                .foregroundStyle(.neutral55)
                .frame(width: 30, alignment: .leading)
            
            Text(content)
                .fontStyle(.body2)
                .foregroundStyle(.neutral25)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(.neutral95)
        )
    }
}

#Preview {
    DiggingNoteView()
}
