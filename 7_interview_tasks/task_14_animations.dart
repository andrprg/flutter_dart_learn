/// ЗАДАЧА 14 — Анимации в Flutter
/// Уровень: Mid Flutter
/// Тема: AnimationController, Tween, Hero, ImplicitAnimations
///
/// Реализуйте три вида анимаций:
///
/// 1. [PulseButton] — кнопка пульсирует (масштаб 1.0 → 1.15 → 1.0) бесконечно
///    Использует: AnimationController + Tween + ScaleTransition
///
/// 2. [AnimatedCard] — карточка появляется с анимацией:
///    - Fade in (прозрачность 0 → 1)
///    - Slide from bottom (сдвиг снизу)
///    Использует: AnimatedOpacity + AnimatedSlide (implicit animations)
///
/// 3. Hero-анимация между двумя экранами:
///    - Список с аватарами (маленькие)
///    - По тапу → переход на детальный экран с большим аватаром
///    - Hero-тег = id элемента
///
/// Вопрос: в чём разница между implicit и explicit анимациями?

import 'package:flutter/material.dart';

// ─── 1. PulseButton ──────────────────────────────────────────────────────────

class PulseButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;

  const PulseButton({super.key, required this.label, this.onPressed});

  @override
  State<PulseButton> createState() => _PulseButtonState();
}

class _PulseButtonState extends State<PulseButton> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: true);

    _scale = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        child: Text(widget.label, style: const TextStyle(fontSize: 18)),
      ),
    );
  }
}

// ─── 2. AnimatedCard ─────────────────────────────────────────────────────────

class AnimatedCard extends StatefulWidget {
  final Widget child;
  final Duration delay;

  const AnimatedCard({super.key, required this.child, this.delay = Duration.zero});

  @override
  State<AnimatedCard> createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<AnimatedCard> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 500),
      child: AnimatedSlide(
        offset: _visible ? Offset.zero : const Offset(0, 0.3),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

// ─── 3. Hero animation ───────────────────────────────────────────────────────

class _AvatarItem {
  final int id;
  final String name;
  final Color color;
  const _AvatarItem(this.id, this.name, this.color);
}

const _avatars = [
  _AvatarItem(1, 'Алиса', Colors.purple),
  _AvatarItem(2, 'Боб', Colors.blue),
  _AvatarItem(3, 'Света', Colors.green),
  _AvatarItem(4, 'Дима', Colors.orange),
];

class AvatarListPage extends StatelessWidget {
  const AvatarListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hero анимация')),
      body: ListView.builder(
        itemCount: _avatars.length,
        itemBuilder: (ctx, i) {
          final item = _avatars[i];
          return ListTile(
            leading: Hero(
              tag: 'avatar_${item.id}',
              child: CircleAvatar(
                backgroundColor: item.color,
                child: Text(item.name[0], style: const TextStyle(color: Colors.white)),
              ),
            ),
            title: Text(item.name),
            onTap: () => Navigator.push(
              ctx,
              MaterialPageRoute(builder: (_) => AvatarDetailPage(item: item)),
            ),
          );
        },
      ),
    );
  }
}

class AvatarDetailPage extends StatelessWidget {
  final _AvatarItem item;
  const AvatarDetailPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(item.name)),
      body: Center(
        child: Hero(
          tag: 'avatar_${item.id}',
          child: CircleAvatar(
            radius: 80,
            backgroundColor: item.color,
            child: Text(
              item.name[0],
              style: const TextStyle(color: Colors.white, fontSize: 60),
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Точка входа ─────────────────────────────────────────────────────────────

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      appBar: AppBar(title: const Text('Анимации Flutter')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(child: PulseButton(label: 'Нажми меня')),
          const SizedBox(height: 32),
          ...List.generate(
            3,
            (i) => AnimatedCard(
              delay: Duration(milliseconds: i * 200),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(title: Text('Карточка ${i + 1}')),
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Hero пример → запусти AvatarListPage'),
          ),
        ],
      ),
    ),
  ));
}
