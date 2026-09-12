/// ЗАДАЧА 23 — Slivers и "одна прокрутка"
/// Уровень: Mid/Senior Flutter
/// Тема: CustomScrollView, SliverAppBar, SliverList, вложенные скроллы
///
/// Частая боль на собеседовании:
/// «Почему у меня дергается прокрутка / конфликтуют скроллы? Как сделать
/// AppBar, который сворачивается, и список в одной прокрутке?»
///
/// Задача:
/// - Исправьте "плохой" экран так, чтобы был один скролл, корректная инерция и
///   сворачивающийся заголовок.
/// - В "хорошем" экране используйте slivers.
///
/// Что искать:
/// - Nested scroll (ListView внутри SingleChildScrollView) → плохо
/// - shrinkWrap + physics для больших списков → дорого
/// - Правильная структура: CustomScrollView + SliverAppBar + SliverList

import 'package:flutter/material.dart';

// ─── ПЛОХОЙ КОД (исправьте архитектуру) ───────────────────────────────────────

class BadSliversScreen extends StatelessWidget {
  const BadSliversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(200, (i) => 'Item $i');

    return Scaffold(
      appBar: AppBar(title: const Text('Bad slivers')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 160,
              width: double.infinity,
              color: Colors.indigo.shade200,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Большая шапка (в идеале — сворачиваемая)',
                style: TextStyle(fontSize: 18),
              ),
            ),
            // ПРОБЛЕМА: ListView внутри SingleChildScrollView.
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, i) => ListTile(title: Text(items[i])),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── ХОРОШИЙ КОД (эталонное решение) ─────────────────────────────────────────

class GoodSliversScreen extends StatelessWidget {
  const GoodSliversScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = List.generate(200, (i) => 'Item $i');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Good slivers'),
              background: Container(
                color: Colors.indigo.shade200,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.all(16),
                child: const Text(
                  'Большая шапка (сворачивается)',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => ListTile(title: Text(items[i])),
              childCount: items.length,
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GoodSliversScreen(),
  ));
}
