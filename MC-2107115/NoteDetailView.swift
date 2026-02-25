import SwiftUI

struct NoteDetailView: View {
	let note: Note
	@ObservedObject var firestoreManager: FirestoreManager
	@Environment(\.presentationMode) var presentationMode
	@State private var showingEditSheet = false
	@State private var showingDeleteAlert = false

	var body: some View {
		VStack(spacing: 0) {
			ScrollView {
				VStack(alignment: .leading, spacing: 16) {
					Text(note.title)
						.font(.largeTitle).bold()

					Divider()

					Text(note.content)
						.font(.body)
						.lineSpacing(8)

					Spacer(minLength: 40)
				}
				.padding()
			}

			Button(role: .destructive) {
				showingDeleteAlert = true
			} label: {
				Text("Delete Note")
					.foregroundColor(.white)
					.frame(maxWidth: .infinity)
					.padding()
					.background(Color.red)
					.cornerRadius(10)
			}
			.padding()
			.alert("Delete Note", isPresented: $showingDeleteAlert) {
				Button("Cancel", role: .cancel) { }
				Button("Delete", role: .destructive) {
					firestoreManager.deleteNote(note)
					presentationMode.wrappedValue.dismiss()
				}
			} message: {
				Text("Are you sure you want to delete this note?")
			}
		}
		.navigationTitle("Note")
		.navigationBarTitleDisplayMode(.inline)
		.toolbar {
			ToolbarItem(placement: .navigationBarTrailing) {
				Button("Edit") {
					showingEditSheet = true
				}
			}
		}
		.sheet(isPresented: $showingEditSheet) {
			AddNoteView(firestoreManager: firestoreManager, noteToEdit: note)
		}
	}
}

#Preview {
	NavigationView {
		NoteDetailView(
			note: Note(id: "1", title: "Sample", content: "Content", userId: "user"),
			firestoreManager: FirestoreManager()
		)
	}
}
