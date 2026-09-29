/// ЗАДАЧА 31 — Валидация формы
/// Уровень: Junior / Mid Flutter
/// Тема: Form, GlobalKey<FormState>, TextFormField, validator
///
/// Допишите [SignUpForm]:
/// - поле email: пустое или без «@» → ошибка «Введите email»
/// - поле пароля: короче 6 символов → ошибка «Минимум 6 символов»
/// - кнопка «Создать» вызывает validate()
/// - после успешной валидации показывается текст «Готово»
///
/// Вопрос: зачем GlobalKey<FormState>, если можно проверить поля вручную?

import 'package:flutter/material.dart';

// ─── Ваше решение ────────────────────────────────────────────────────────────

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  @override
  Widget build(BuildContext context) {
    // TODO: Form + два TextFormField + кнопка
    return const SizedBox.shrink();
  }
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

class SignUpFormAnswer extends StatefulWidget {
  const SignUpFormAnswer({super.key});

  @override
  State<SignUpFormAnswer> createState() => _SignUpFormAnswerState();
}

class _SignUpFormAnswerState extends State<SignUpFormAnswer> {
  final _formKey = GlobalKey<FormState>();
  var _submitted = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            key: const Key('email'),
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty || !text.contains('@')) return 'Введите email';
              return null;
            },
          ),
          TextFormField(
            key: const Key('password'),
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Пароль'),
            validator: (value) {
              if ((value ?? '').length < 6) return 'Минимум 6 символов';
              return null;
            },
          ),
          ElevatedButton(
            key: const Key('submit'),
            onPressed: () {
              final valid = _formKey.currentState?.validate() ?? false;
              setState(() => _submitted = valid);
            },
            child: const Text('Создать'),
          ),
          if (_submitted) const Text('Готово'),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(home: Scaffold(body: SignUpFormAnswer())));
}
