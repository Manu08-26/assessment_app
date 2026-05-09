import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/note_model.dart';

class NoteRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  NoteRepository({FirebaseAuth? auth, FirebaseFirestore? firestore})
      : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  String get _uid {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      throw StateError('User not logged in');
    }
    return uid;
  }

  CollectionReference<Map<String, dynamic>> _notesCollection() {
    return _firestore.collection('users').doc(_uid).collection('notes');
  }

  Stream<List<Note>> watchNotes() {
    return _notesCollection()
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(Note.fromDoc).toList());
  }

  Future<void> createNote({required String title, required String content}) async {
    final note = Note(
      id: '',
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _notesCollection().add(note.toMapForCreate());
  }

  Future<void> updateNote({
    required String noteId,
    required String title,
    required String content,
  }) async {
    final note = Note(
      id: noteId,
      title: title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    await _notesCollection().doc(noteId).update(note.toMapForUpdate());
  }

  Future<void> deleteNote(String noteId) async {
    await _notesCollection().doc(noteId).delete();
  }
}
