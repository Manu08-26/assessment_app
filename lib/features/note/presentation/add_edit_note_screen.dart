import 'package:flutter/material.dart';

import '../controller/note_controller.dart';
import '../model/note_model.dart';
import '../../../core/utils/app_snackbar.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final controller = NoteController();
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController contentController;

  bool saving = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    contentController = TextEditingController(text: widget.note?.content ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    final title = titleController.text.trim();
    final content = contentController.text.trim();

    setState(() {
      saving = true;
    });

    try {
      if (widget.note == null) {
        await controller.createNote(title: title, content: content);
      } else {
        await controller.updateNote(
          noteId: widget.note!.id,
          title: title,
          content: content,
        );
      }

      if (!mounted) return;
      AppSnackBar.success(context, widget.note == null ? 'Note created' : 'Note updated');
      Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        AppSnackBar.error(context, e.toString());
      }
    } finally {
      if (mounted) {
        setState(() {
          saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.note != null;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Edit Note' : 'Add Note'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton(
              onPressed: saving ? null : save,
              child: Text(saving ? 'Saving...' : 'Save'),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          child: FilledButton.icon(
            onPressed: saving ? null : save,
            icon: Icon(isEdit ? Icons.save_outlined : Icons.add),
            label: Text(saving ? 'Saving...' : (isEdit ? 'Update note' : 'Create note')),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: scheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Icon(isEdit ? Icons.edit_note : Icons.note_add_outlined),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              isEdit ? 'Update your note' : 'Create a new note',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: titleController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        final v = value?.trim() ?? '';
                        if (v.isEmpty) return 'Title is required';
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        prefixIcon: Icon(Icons.title),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: TextFormField(
                        controller: contentController,
                        maxLines: null,
                        expands: true,
                        validator: (value) {
                          final v = value?.trim() ?? '';
                          if (v.isEmpty) return 'Content is required';
                          return null;
                        },
                        decoration: const InputDecoration(
                          labelText: 'Content',
                          alignLabelWithHint: true,
                          prefixIcon: Icon(Icons.notes_outlined),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
