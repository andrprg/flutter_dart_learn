/// ЗАДАЧА 33 — Key и сохранение State при перестановке
/// Уровень: Mid Flutter
/// Тема: ValueKey, Element, сопоставление виджетов
///
/// Список заметок можно развернуть. У каждой заметки свой TextField.
/// Без ключа Flutter сопоставляет элементы по позиции, и текст «переезжает»
/// не на ту карточку.
///
/// Допишите [NotesReorder]:
/// - каждая карточка имеет ValueKey(note.id)
/// - кнопка «Развернуть» меняет порядок на обратный
/// - введённый текст остаётся у той же заметки
///
/// Вопрос: когда ValueKey, ObjectKey, UniqueKey и GlobalKey?

import 'package:flutter/material.dart';

class Note {
  final String id;
  final String title;
  const Note({required this.id, required this.title});
}

// ─── Ваше решение ────────────────────────────────────────────────────────────

class NotesReorder extends StatefulWidget {
  const NotesReorder({super.key, required this.notes});

  final List<Note> notes;

  @override
  State<NotesReorder> createState() => _NotesReorderState();
}

class _NotesReorderState extends State<NotesReorder> {
  @override
  Widget build(BuildContext context) {
    // TODO: ValueKey на каждой карточке и кнопка разворота списка
    return const SizedBox.shrink();
  }
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

class NotesReorderAnswer extends StatefulWidget {
  const NotesReorderAnswer({super.key, required this.notes});

  final List<Note> notes;

  @override
  State<NotesReorderAnswer> createState() => _NotesReorderAnswerState();
}

class _NotesReorderAnswerState extends State<NotesReorderAnswer> {
  late List<Note> _notes = List<Note>.of(widget.notes);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          key: const Key('reverse'),
          onPressed: () => setState(() => _notes = _notes.reversed.toList()),
          child: const Text('Развернуть'),
        ),
        for (final note in _notes)
          NoteFieldAnswer(key: ValueKey(note.id), note: note),
      ],
    );
  }
}

class NoteFieldAnswer extends StatefulWidget {
  const NoteFieldAnswer({super.key, required this.note});

  final Note note;

  @override
  State<NoteFieldAnswer> createState() => _NoteFieldAnswerState();
}

class _NoteFieldAnswerState extends State<NoteFieldAnswer> {
  late final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.note.title),
        TextField(
          key: Key('field-${widget.note.id}'),
          controller: _controller,
        ),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: NotesReorderAnswer(
          notes: [
            Note(id: '1', title: 'Первая'),
            Note(id: '2', title: 'Вторая'),
          ],
        ),
      ),
    ),
  );
}
