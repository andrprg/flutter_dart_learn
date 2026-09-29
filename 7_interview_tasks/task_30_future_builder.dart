/// ЗАДАЧА 30 — FutureBuilder: loading / data / error
/// Уровень: Junior / Mid Flutter
/// Тема: FutureBuilder, AsyncSnapshot
///
/// Допишите [ProfileLoader]:
/// - пока Future не завершился — текст «Загрузка...»
/// - при ошибке — текст «Ошибка»
/// - при успехе — имя пользователя из [UserCard]
///
/// Вопрос: почему Future нельзя создавать внутри build без мемоизации?

import 'package:flutter/material.dart';

class UserCard {
  final String name;
  const UserCard({required this.name});
}

// ─── Ваше решение ────────────────────────────────────────────────────────────

class ProfileLoader extends StatelessWidget {
  const ProfileLoader({super.key, required this.future});

  final Future<UserCard> future;

  @override
  Widget build(BuildContext context) {
    // TODO: FutureBuilder с тремя состояниями
    return const SizedBox.shrink();
  }
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

class ProfileLoaderAnswer extends StatelessWidget {
  const ProfileLoaderAnswer({super.key, required this.future});

  final Future<UserCard> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserCard>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Text('Загрузка...');
        }
        if (snapshot.hasError) {
          return const Text('Ошибка');
        }
        final user = snapshot.data;
        if (user == null) return const Text('Ошибка');
        return Text(user.name);
      },
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        body: ProfileLoaderAnswer(
          future: Future<UserCard>.delayed(
            const Duration(milliseconds: 300),
            () => const UserCard(name: 'Анна'),
          ),
        ),
      ),
    ),
  );
}
