import Foundation
import Combine
import SwiftUI

@MainActor
class DiggingNoteDetailViewModel: ObservableObject {
    @Published var note: Note?
    @Published var ticket: Ticket?
    
    @Published var isLoading: Bool = false
    @Published var isMenuPresent = false
    @Published var isEditMode = false
    @Published var noteDeleted = false
    @Published var editableContents: [NoteContent] = []
    @Published var isSaving: Bool = false

    let noteUseCase: NoteUseCase
    let ticketUseCase: TicketUseCase
    init(
        noteUseCase: NoteUseCase = NoteUseCase(),
        ticketUseCase: TicketUseCase = TicketUseCase(),
        noteId: Int,
        ticketId: Int
    ) {
        self.noteUseCase = noteUseCase
        self.ticketUseCase = ticketUseCase
        getTicket(ticketId: ticketId)
        getNoteDetail(noteId: noteId)
    }

    func getTicket(ticketId: Int) {
        Task {
            do {
                isLoading = true
                ticket = try await ticketUseCase.getTicketDetail(ticketId: ticketId)
                isLoading = false
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("티켓 상세 조회"))
            }
        }
    }
    
    func getNoteDetail(noteId: Int) {
        Task {
            do {
                isLoading = true
                note = try await noteUseCase.getNoteDetail(noteId: noteId)
                editableContents = note?.contents ?? []
                isLoading = false
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("노트 상세 조회"))
            }
        }
    }

    func toggleEditMode() {
        if isEditMode {
            editableContents = note?.contents ?? []
        }
        isEditMode.toggle()
    }

    func getAnswerBinding(for index: Int) -> Binding<String> {
        Binding(
            get: {
                guard self.editableContents.indices.contains(index) else { return "" }
                return self.editableContents[index].answer
            },
            set: { newValue in
                guard self.editableContents.indices.contains(index) else { return }
                self.editableContents[index] = NoteContent(
                    question: self.editableContents[index].question,
                    answer: newValue
                )
            }
        )
    }

    func saveNote() async -> Bool {
        guard let currentNote = note else { return false }

        do {
            isSaving = true
            let updatedNote = try await noteUseCase.updateNote(
                noteId: currentNote.id,
                contents: editableContents
            )

            await MainActor.run {
                note = updatedNote
                editableContents = updatedNote.contents
                isSaving = false
                isEditMode = false
                ToastManager.shared.show(.success("노트가 수정되었습니다"))
            }

            return true
        } catch {
            await MainActor.run {
                isSaving = false
                ToastManager.shared.show(.errorStringWithTask("노트 수정"))
            }
            return false
        }
    }

    func showDeleteConfirmation() {
        PopupManager.shared.show(
            .deleteNoteWarning(
                onClick: {
                    self.deleteNote()
                }
            )
        )
    }

    private func deleteNote() {
        Task {
            do {
                guard let currentNote = note else { return }

                isLoading = true
                try await noteUseCase.deleteNote(noteId: currentNote.id)

                await MainActor.run {
                    isLoading = false
                    noteDeleted = true
                    ToastManager.shared.show(.success("노트가 삭제되었습니다"))
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                    ToastManager.shared.show(.errorStringWithTask("노트 삭제"))
                }
            }
        }
    }
}
