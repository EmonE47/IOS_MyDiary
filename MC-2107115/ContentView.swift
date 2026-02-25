import SwiftUI

struct ContentView: View {
    @StateObject private var firestoreManager = FirestoreManager()
    @State private var showingAddNote = false
    @State private var selectedNote: Note?
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(firestoreManager.notes) { note in
                        NavigationLink(
                            destination: NoteDetailView(
                                note: note, firestoreManager: firestoreManager)
                        ) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(note.title)
                                    .font(.headline)
                                Text(note.content)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                            .padding(.vertical, 8)
                        }
                        .swipeActions {
                            Button("Delete") {
                                firestoreManager.deleteNote(note)
                            }
                            .tint(.red)

                            Button("Edit") {
                                selectedNote = note
                            }
                            .tint(.blue)
                        }
                    }
                    .listRowBackground(Color(.systemGray6).opacity(0.3))
                }
                .listStyle(.plain)
                .onAppear {
                    firestoreManager.getNotes()
                }

                Button(action: { authViewModel.signOut() }) {
                    Text("Sign Out")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(14)
                        .shadow(color: .blue.opacity(0.3), radius: 3, x: 0, y: 2)
                }
                .padding()
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        selectedNote = nil
                        showingAddNote = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(item: $selectedNote) { note in
                AddNoteView(firestoreManager: firestoreManager, noteToEdit: note)
            }
            .sheet(isPresented: $showingAddNote) {
                AddNoteView(firestoreManager: firestoreManager, noteToEdit: nil)
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthViewModel())
}
