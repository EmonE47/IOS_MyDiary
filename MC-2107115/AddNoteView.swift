import SwiftUI

struct AddNoteView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var firestoreManager: FirestoreManager
    var noteToEdit: Note?

    @State private var title = ""
    @State private var content = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Note Details")) {
                    TextField("Title", text: $title)
                    TextEditor(text: $content)
                        .frame(minHeight: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(.systemGray4), lineWidth: 1)
                        )
                        .background(Color(.systemGray6))
                }

                Button("Save") {
                    if let note = noteToEdit {
                        var updatedNote = note
                        updatedNote.title = title
                        updatedNote.content = content
                        firestoreManager.updateNote(updatedNote)
                    } else {
                        firestoreManager.addNote(title: title, content: content)
                    }
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .frame(maxWidth: .infinity)
                .disabled(title.isEmpty || content.isEmpty)
            }
            .navigationTitle(noteToEdit == nil ? "Add Note" : "Edit Note")
            .navigationBarItems(trailing: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .onAppear {
                if let note = noteToEdit {
                    title = note.title
                    content = note.content
                }
            }
        }
    }
}

#Preview {
    Text("AddNoteView preview – run in simulator to test")
}
