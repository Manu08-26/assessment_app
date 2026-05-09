import '../data/note_repository.dart';
import '../model/note_model.dart';

class NoteController {
  final NoteRepository _repo;

  NoteController({NoteRepository? repo}) : _repo = repo ?? NoteRepository();

  Stream<List<Note>> watchNotes() => _repo.watchNotes();

  Future<void> createNote({required String title, required String content}) {
    return _repo.createNote(title: title, content: content);
  }

  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) {
    return _repo.updateNote(noteId: noteId, title: title, content: content);
  }

  Future<void> deleteNote(String noteId) {
    return _repo.deleteNote(noteId);
  }
}
