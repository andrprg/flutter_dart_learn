/// ЗАДАЧА 24 — State Restoration (RestorationMixin)
/// Уровень: Senior Flutter
/// Тема: RestorationMixin, RestorableInt, RestorableTextEditingController
///
/// На собеседовании часто спрашивают:
/// «Как сделать, чтобы состояние экрана восстанавливалось после убийства
/// процесса ОС или при возвращении в приложение?»
///
/// Задача:
/// - Допишите виджет [RestorableNotesScreen], чтобы:
///   - счётчик и текстовое поле восстанавливались автоматически
///   - restorationId был задан
///   - restorable-свойства были зарегистрированы корректно
///
/// Подсказка:
/// - Используйте [RestorationMixin]
/// - Используйте [RestorableInt] и [RestorableTextEditingController]
/// - Не забудьте вызвать `registerForRestoration`

import 'package:flutter/material.dart';

// ─── Ваше решение ────────────────────────────────────────────────────────────

class RestorableNotesScreen extends StatefulWidget {
  const RestorableNotesScreen({super.key});

  @override
  State<RestorableNotesScreen> createState() => _RestorableNotesScreenState();
}

class _RestorableNotesScreenState extends State<RestorableNotesScreen>
    with RestorationMixin {
  // TODO: заведите RestorableInt и RestorableTextEditingController

  @override
  String? get restorationId {
    // TODO: верните стабильный id (например 'restorable_notes')
    return null;
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    // TODO: registerForRestoration(...)
  }

  @override
  void dispose() {
    // TODO: освобождение ресурсов у restorable контроллера
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: используйте значения из restorable объектов
    return const SizedBox.shrink();
  }
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

class RestorableNotesScreenAnswer extends StatefulWidget {
  const RestorableNotesScreenAnswer({super.key});

  @override
  State<RestorableNotesScreenAnswer> createState() =>
      _RestorableNotesScreenAnswerState();
}

class _RestorableNotesScreenAnswerState
    extends State<RestorableNotesScreenAnswer> with RestorationMixin {
  final RestorableInt _counter = RestorableInt(0);
  final RestorableTextEditingController _controller =
      RestorableTextEditingController();

  @override
  String? get restorationId => 'restorable_notes';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_counter, 'counter');
    registerForRestoration(_controller, 'note_text');
  }

  @override
  void dispose() {
    _counter.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('State restoration')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Counter: ${_counter.value}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => setState(() => _counter.value++),
                  child: const Text('+1'),
                ),
                OutlinedButton(
                  onPressed: () => setState(() => _counter.value = 0),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller.value,
              decoration: const InputDecoration(
                labelText: 'Заметка (восстанавливается)',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            const Text(
              'Подсказка: попробуйте включить "State Restoration" в DevTools '
              'или пересоздать приложение — состояние должно восстановиться.',
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    restorationScopeId: 'app',
    home: RestorableNotesScreenAnswer(),
  ));
}
