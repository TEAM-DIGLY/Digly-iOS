import Foundation
import Combine
import SwiftUI

@MainActor
class DiggingNoteDetailViewModel: ObservableObject {
    @Published var note: Note?
    @Published var isLoading: Bool = false
    @Published var isMenuPresent = false
    @Published var noteDeleted = false

    let noteUseCase: NoteUseCase

    init(
        noteUseCase: NoteUseCase = NoteUseCase()
    ) {
        self.noteUseCase = noteUseCase
    }

    func getNoteDetail(noteId: Int) {
        Task {
            do {
                isLoading = true
                note = try await noteUseCase.getNoteDetail(noteId: noteId)
                isLoading = false
            } catch {
                isLoading = false
                ToastManager.shared.show(.errorStringWithTask("노트 상세 조회"))
            }
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
