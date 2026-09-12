// ignore_for_file: unused_import
import 'package:flutter/material.dart';

// ============================================================
// 20 ЗАДАЧ ПО PROMPT ENGINEERING ДЛЯ FLUTTER-РАЗРАБОТЧИКА
// ============================================================
// Цель: освоить prompt engineering через практику в Cursor.
//
// Как выполнять задачи:
//   1. Прочитай описание задачи.
//   2. Напиши промпт в секции "// ТВОЙ ПРОМПТ:".
//   3. Отправь промпт в Cursor Chat / Composer.
//   4. Вставь полученный код вместо throw UnimplementedError().
//   5. Оцени результат (⭐ 1–5) и запиши что улучшить.
//
// Метрика успеха: результат подошёл без доработки с первой попытки.
// ============================================================

// ─── Фаза 1: Базовые промпты (1–5) ───────────────────────────────────────────

// ЗАДАЧА 1 — Конкретность запроса
// Сравни два подхода к промпту.
//
// Шаг 1: Напиши размытый промпт, получи результат.
// Шаг 2: Напиши конкретный промпт, получи результат.
// Шаг 3: Используй лучший результат как реализацию.
//
// Что нужно реализовать:
//   WelcomeCard — StatelessWidget, карточка приветствия:
//   — градиентный фон (синий → фиолетовый), borderRadius 20
//   — имя пользователя жирным (fontSize 22, белый)
//   — подзаголовок "Добро пожаловать!" (fontSize 14, белый 80% opacity)
//   — padding 24 со всех сторон
//
// ТВОЙ ПРОМПТ (размытый):
// ...напиши здесь...
//
// ТВОЙ ПРОМПТ (конкретный):
// ...напиши здесь...
//
// Что сработало лучше и почему:
// ...

class WelcomeCard extends StatelessWidget {
  final String userName;
  const WelcomeCard({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 2 — Шаблон ROLE + TASK + FORMAT
// Используй структуру: кто ты → что сделать → в каком формате ответить.
//
// Что нужно реализовать:
//   PriceTag — StatelessWidget, ценник товара:
//   — старая цена зачёркнута (серый, fontSize 14)
//   — новая цена крупным шрифтом (зелёный, fontSize 22, bold)
//   — бейдж "СКИДКА −30%" (красный фон, белый текст, borderRadius 8)
//
// ТВОЙ ПРОМПТ (используй ROLE + TASK + FORMAT):
// [РОЛЬ]: ...
// [ЗАДАЧА]: ...
// [ОГРАНИЧЕНИЯ]: ...
// [ФОРМАТ ОТВЕТА]: ...
//
// Оценка результата (⭐ 1–5): ...
// Что улучшить в промпте: ...

class PriceTag extends StatelessWidget {
  final double oldPrice;
  final double newPrice;
  final int discountPercent;
  const PriceTag({
    super.key,
    required this.oldPrice,
    required this.newPrice,
    required this.discountPercent,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 3 — Chain of Thought (пошаговое мышление)
// Добавь в промпт инструкцию "думай шаг за шагом".
//
// Что нужно реализовать:
//   StepperProgress — StatelessWidget, индикатор шагов онбординга:
//   — 3 круга соединённых линиями (активный — синий, пройденный — галочка,
//     предстоящий — серый)
//   — подпись под каждым шагом (текст передаётся параметром)
//   — текущий шаг передаётся параметром currentStep (0, 1 или 2)
//
// ТВОЙ ПРОМПТ (без CoT):
// ...
//
// ТВОЙ ПРОМПТ (с "думай шаг за шагом"):
// ...
//
// Разница в качестве результата:
// ...

class StepperProgress extends StatelessWidget {
  final int currentStep;
  final List<String> stepLabels;
  const StepperProgress({
    super.key,
    required this.currentStep,
    required this.stepLabels,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 4 — Few-Shot: обучение на примерах
// Покажи AI 2 примера виджета → попроси создать третий в том же стиле.
//
// Что нужно реализовать:
//   StatWidget — карточка статистики (иконка + число + подпись).
//   Стиль должен соответствовать двум примерам ниже (передай их в промпт):
//
//   Пример 1 — карточка "Подписчики":
//     Container(padding: 16, decoration: rounded white card with shadow)
//       Column: Icon(Icons.people, blue), Text("1.2K", bold 24), Text("Подписчики", grey 12)
//
//   Пример 2 — карточка "Лайки":
//     Container(same style)
//       Column: Icon(Icons.favorite, red), Text("4.8K", bold 24), Text("Лайки", grey 12)
//
// ТВОЙ ПРОМПТ (few-shot с примерами):
// ...
//
// Оценка: промпт попал в стиль с первого раза? (да/нет): ...

class StatWidget extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;
  const StatWidget({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 5 — Промпт с ограничениями (Constraints)
// Добавь явные ограничения: без лишних пакетов, без определённых виджетов.
//
// Что нужно реализовать:
//   RatingBar — виджет рейтинга из 5 звёзд:
//   — закрашенные звёзды соответствуют рейтингу (double, например 3.5)
//   — поддержка половинок звезды
//   — размер и цвет звёзд передаются параметрами
//
// ТВОЙ ПРОМПТ (с явными ограничениями):
// — Не использовать сторонние пакеты
// — Только стандартный Flutter SDK
// — Не использовать CustomPainter (только Icon)
// ...
//
// Что произошло когда нарушил ограничения (попробуй без них):
// ...

class RatingBar extends StatelessWidget {
  final double rating;
  final double starSize;
  final Color activeColor;
  const RatingBar({
    super.key,
    required this.rating,
    this.starSize = 24,
    this.activeColor = Colors.amber,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ─── Фаза 2: Продвинутые техники (6–12) ──────────────────────────────────────

// ЗАДАЧА 6 — Prompt Chaining: разбивка на шаги
// Реализуй экран через цепочку из 3 промптов (не одним большим).
//
// Что нужно реализовать:
//   SearchScreen — экран поиска с:
//   — AppBar с кнопкой назад
//   — TextField с иконкой поиска и кнопкой очистки
//   — список результатов (ListView) или пустое состояние "Ничего не найдено"
//   — состояние загрузки (CircularProgressIndicator)
//
// ПРОМПТ 1 (только архитектура — классы и State):
// ...
//
// ПРОМПТ 2 (только UI виджеты на основе архитектуры из шага 1):
// ...
//
// ПРОМПТ 3 (только логика поиска и состояния):
// ...
//
// Вывод: цепочка дала лучший результат чем один большой промпт? (да/нет): ...

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 7 — Мета-промпт: попроси AI улучшить твой промпт
//
// Шаг 1: Напиши свой первоначальный промпт для задачи.
// Шаг 2: Отправь в Cursor: "Улучши этот промпт. Объясни что и почему изменил: [промпт]"
// Шаг 3: Используй улучшенный промпт для реализации виджета.
//
// Что нужно реализовать:
//   NotificationItem — строка уведомления в списке:
//   — аватар отправителя (CircleAvatar)
//   — заголовок + текст превью (обрезать после 2 строк)
//   — время (правый верхний угол)
//   — индикатор непрочитанного (синяя точка)
//   — onTap callback
//
// МОЙ ПЕРВОНАЧАЛЬНЫЙ ПРОМПТ:
// ...
//
// УЛУЧШЕННЫЙ ПРОМПТ (от AI):
// ...
//
// Что AI изменил (своими словами):
// ...

class NotificationItem extends StatelessWidget {
  final String senderName;
  final String senderInitial;
  final String title;
  final String preview;
  final String time;
  final bool isUnread;
  final VoidCallback? onTap;

  const NotificationItem({
    super.key,
    required this.senderName,
    required this.senderInitial,
    required this.title,
    required this.preview,
    required this.time,
    this.isUnread = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 8 — Промпт для дебаггинга
// Используй шаблон: проблема + что ожидал + что происходит + код.
//
// Шаг 1: Реализуй AnimatedCounter (неправильно — с багом).
// Шаг 2: Сломай анимацию намеренно.
// Шаг 3: Напиши промпт для поиска бага по шаблону ниже.
//
// Что нужно реализовать:
//   AnimatedCounter — счётчик с анимацией изменения числа:
//   — при изменении значения число "выезжает" снизу вверх
//   — старое число "уезжает" вверх
//   — длительность анимации 300ms
//
// ПРОМПТ ДЕБАГГИНГА (используй шаблон):
// [КОНТЕКСТ]: Flutter приложение, виджет AnimatedCounter
// [ПРОБЛЕМА]: ...что происходит неправильно...
// [ОЖИДАНИЕ]: ...что должно происходить...
// [ВОСПРОИЗВЕДЕНИЕ]: ...шаги для воспроизведения...
// [УЖЕ ПРОВЕРИЛ]: ...что пробовал...
// [КОД]: ...вставить код...
//
// Насколько точным оказался диагноз AI (⭐ 1–5): ...

class AnimatedCounter extends StatefulWidget {
  final int value;
  const AnimatedCounter({super.key, required this.value});

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 9 — Промпт для Code Review
// Попроси AI провести ревью твоего кода по конкретным критериям.
//
// Шаг 1: Реализуй ProductCard самостоятельно (пиши как умеешь).
// Шаг 2: Отправь код на ревью промптом ниже.
// Шаг 3: Исправь все критичные замечания.
//
// Что нужно реализовать:
//   ProductCard — карточка товара в каталоге:
//   — изображение (Image.network с fallback при ошибке)
//   — название товара (максимум 2 строки)
//   — цена
//   — кнопка "В корзину"
//   — InkWell с ripple эффектом на весь виджет
//
// ПРОМПТ CODE REVIEW:
// "Ты — строгий senior Flutter reviewer.
//  Проверь код по критериям:
//  1. Архитектурные проблемы (критично)
//  2. Производительность (важно)
//  3. Обработка ошибок (важно)
//  4. Читаемость (незначительно)
//  Для каждой проблемы: [уровень] → [описание] → [исправление]"
//
// Сколько критичных замечаний получил: ...
// Главный инсайт из ревью: ...

class ProductCard extends StatelessWidget {
  final String title;
  final double price;
  final String imageUrl;
  final VoidCallback onAddToCart;

  const ProductCard({
    super.key,
    required this.title,
    required this.price,
    required this.imageUrl,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 10 — Итеративное улучшение промпта
// Улучшай промпт 3 раза, записывая версии и оценки.
//
// Что нужно реализовать:
//   BottomNavBar — кастомный нижний навбар:
//   — 4 пункта меню (иконка + подпись)
//   — активный пункт: иконка и текст синим, подчёркивание
//   — неактивный: серый
//   — анимация переключения 200ms
//   — индикатор уведомлений (красная точка над иконкой)
//
// ВЕРСИЯ 1 промпта: ...  | Оценка: ⭐
// ВЕРСИЯ 2 (что улучшил): ...  | Оценка: ⭐⭐
// ВЕРСИЯ 3 (что улучшил): ...  | Оценка: ⭐⭐⭐
//
// Главное изменение между версиями:
// ...

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<Map<String, dynamic>> items;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 11 — Промпт для генерации тестов
// Сначала напиши виджет, потом попроси AI написать тесты.
//
// Что нужно реализовать + протестировать:
//   ToggleSwitch — кастомный переключатель:
//   — анимированный слайдер (300ms)
//   — активное состояние: синий фон, белый кружок справа
//   — неактивное: серый фон, белый кружок слева
//   — onChanged callback
//
// ПРОМПТ ДЛЯ ТЕСТОВ:
// "Напиши widget tests для ToggleSwitch.
//  Покрой сценарии:
//  1. Начальное состояние (isOn: false)
//  2. Начальное состояние (isOn: true)
//  3. Tap вызывает onChanged с противоположным значением
//  4. Виджет корректно перерисовывается после смены состояния
//  Используй flutter_test, WidgetTester."
//
// Тесты прошли сразу? (да/нет): ...
// Что пришлось исправить: ...

class ToggleSwitch extends StatelessWidget {
  final bool isOn;
  final ValueChanged<bool> onChanged;

  const ToggleSwitch({
    super.key,
    required this.isOn,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 12 — Cursor Rules: системный промпт для проекта
//
// Шаг 1: Создай файл .cursor/rules/flutter_style.md
// Шаг 2: Наполни его правилами стиля на основе промпта ниже.
// Шаг 3: Реализуй UserAvatar и убедись что AI следует правилам.
//
// ПРОМПТ ДЛЯ ГЕНЕРАЦИИ ПРАВИЛ:
// "Ты — tech lead Flutter команды.
//  Создай Cursor Rules файл для Flutter проекта.
//  Включи правила по:
//  — именованию (классы, методы, переменные)
//  — структуре виджетов (const, key)
//  — обработке ошибок
//  — стилю кода (dart style guide)
//  Формат: markdown, конкретные примеры DO / DON'T"
//
// Что нужно реализовать:
//   UserAvatar — аватар с онлайн-индикатором:
//   — фото (Image.network) или инициалы если нет фото
//   — зелёная точка если isOnline: true
//   — размер: small (32), medium (48), large (64)
//
// AI следовал правилам из Rules-файла? (да/нет): ...

enum AvatarSize { small, medium, large }

class UserAvatar extends StatelessWidget {
  final String? imageUrl;
  final String initials;
  final bool isOnline;
  final AvatarSize size;

  const UserAvatar({
    super.key,
    this.imageUrl,
    required this.initials,
    this.isOnline = false,
    this.size = AvatarSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ─── Фаза 3: Сложные сценарии (13–17) ────────────────────────────────────────

// ЗАДАЧА 13 — Промпт для сложного layout
// Используй Cursor Composer для multi-file генерации.
//
// Что нужно реализовать (через Composer, один промпт):
//   Полный экран профиля пользователя:
//   — profile_screen.dart    : основной экран
//   — profile_header.dart    : шапка с фото, именем, кнопками
//   — profile_stats_row.dart : строка статистики (посты / подписчики / подписки)
//   — profile_grid.dart      : сетка публикаций 3 колонки
//
// ПРОМПТ ДЛЯ COMPOSER:
// "Создай 4 файла для экрана профиля пользователя Instagram-стиля.
//  Архитектура: StatelessWidget везде, данные передаются параметрами.
//  [опиши каждый файл подробно]
//  Придерживайся Material 3, Flutter 3.x, null safety."
//
// Количество файлов созданных с первого промпта: ...
// Что пришлось доработать: ...

class ProfileScreen extends StatelessWidget {
  final String name;
  final String username;
  final String? avatarUrl;
  final int postsCount;
  final int followersCount;
  final int followingCount;

  const ProfileScreen({
    super.key,
    required this.name,
    required this.username,
    this.avatarUrl,
    required this.postsCount,
    required this.followersCount,
    required this.followingCount,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 14 — Промпт для оптимизации производительности
// Сначала получи медленную версию, потом промптом оптимизируй.
//
// Что нужно реализовать:
//   PhotoGrid — сетка фотографий (GridView.builder, 500+ элементов):
//   — lazy loading при скролле
//   — кэширование изображений
//   — placeholder при загрузке
//   — анимация появления элементов
//
// ПРОМПТ ВЕРСИИ 1 (быстрая реализация без учёта производительности):
// ...
//
// ПРОМПТ ОПТИМИЗАЦИИ:
// "Отрефактори PhotoGrid для высокой производительности.
//  Применить:
//  1. const конструкторы где возможно
//  2. Кэширование: избежать повторных build
//  3. RepaintBoundary для изолированных элементов
//  4. Объясни каждое изменение и его влияние на FPS"
//
// Прирост производительности (субъективно): ...

class PhotoGrid extends StatelessWidget {
  final List<String> photoUrls;
  const PhotoGrid({super.key, required this.photoUrls});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 15 — Промпт для рефакторинга legacy-кода
//
// Шаг 1: Напиши "плохой" код виджета (длинный build, вся логика внутри).
// Шаг 2: Попроси AI отрефакторить по принципам ниже.
// Шаг 3: Сравни до/после.
//
// Что нужно реализовать (сначала "плохо", потом отрефакторить):
//   CheckoutForm — форма оформления заказа:
//   — поля: имя, адрес, город, индекс, телефон
//   — валидация каждого поля
//   — кнопка "Оформить" (активна только если форма валидна)
//   — показ ошибок под полями
//
// ПРОМПТ РЕФАКТОРИНГА:
// "Отрефактори CheckoutForm следуя принципам:
//  1. Разбей build() на приватные методы (каждый < 20 строк)
//  2. Вынеси валидаторы в отдельные функции
//  3. Используй Form + TextFormField правильно
//  4. Убери дублирование
//  Покажи diff: что именно изменилось и почему."
//
// Уменьшение строк в build(): было ___ → стало ___

class CheckoutForm extends StatefulWidget {
  final VoidCallback onSubmit;
  const CheckoutForm({super.key, required this.onSubmit});

  @override
  State<CheckoutForm> createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 16 — Промпт для создания кастомного Theme
//
// Что нужно реализовать:
//   AppTheme — класс с Material 3 темой для приложения:
//   — светлая и тёмная тема
//   — кастомная цветовая схема (основной: синий, акцент: оранжевый)
//   — типографика: заголовки Roboto Slab, текст Roboto
//   — стили кнопок, карточек, полей ввода
//
// ПРОМПТ (опиши бренд → получи тему):
// "Ты — Flutter UI/UX эксперт.
//  Создай Material 3 ThemeData для фитнес-приложения:
//  — Бренд: энергичный, молодёжный, спортивный
//  — Основной цвет: #FF6B35 (оранжевый)
//  — Дополнительный: #2C3E50 (тёмно-синий)
//  — Обе темы: светлая и тёмная
//  Включи: ColorScheme, TextTheme, ButtonTheme, CardTheme, InputDecorationTheme"
//
// AI подобрал palette самостоятельно? (да/нет): ...
// Что пришлось скорректировать вручную: ...

class AppTheme {
  static ThemeData get light => throw UnimplementedError();
  static ThemeData get dark => throw UnimplementedError();
}

// ЗАДАЧА 17 — Промпт для accessibility (a11y)
//
// Что нужно реализовать:
//   AccessibleButton — кнопка с полной поддержкой accessibility:
//   — Semantics label и hint
//   — минимальный размер touch target 48x48
//   — поддержка screen reader
//   — высокий контраст текста
//   — состояния: normal / loading / disabled / success
//
// ПРОМПТ (с фокусом на a11y):
// "Создай Flutter кнопку с полной поддержкой accessibility.
//  Требования WCAG 2.1:
//  — контраст текста минимум 4.5:1
//  — touch target 48x48 минимум
//  — Semantics: label, hint, enabled, button role
//  Состояния: [normal, loading, disabled, success] с правильной Semantics для каждого."
//
// Проверь с TalkBack/VoiceOver: работает корректно? (да/нет): ...

enum ButtonState { normal, loading, disabled, success }

class AccessibleButton extends StatelessWidget {
  final String label;
  final String semanticsHint;
  final VoidCallback? onPressed;
  final ButtonState state;

  const AccessibleButton({
    super.key,
    required this.label,
    required this.semanticsHint,
    this.onPressed,
    this.state = ButtonState.normal,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ─── Фаза 4: Мастерство (18–20) ───────────────────────────────────────────────

// ЗАДАЧА 18 — Полный фичер одним Composer промптом
//
// Реализуй полный экран "Список задач" (Todo App) через ОДИН промпт в Composer.
// Критерий успеха: рабочий код без доработок.
//
// Требования к экрану:
//   — добавление задачи (TextField + кнопка)
//   — список задач (ListView)
//   — отметка выполненной (Checkbox, зачёркивание)
//   — удаление свайпом (Dismissible)
//   — фильтр: все / активные / выполненные (ToggleButtons)
//   — счётчик оставшихся задач
//   — состояние через setState (без Riverpod)
//
// ТВОЙ ФИНАЛЬНЫЙ ПРОМПТ (потрать на него время, сделай максимально точным):
// ...
//
// Результат с первого раза: ___% работающего кода
// Количество итераций до финала: ___

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 19 — Создание личного шаблона промпта
//
// На основе опыта из задач 1–18 создай свой универсальный шаблон.
//
// Задание:
//   1. Проанализируй свой дневник промптов (какие элементы давали лучший результат)
//   2. Напиши финальный шаблон в секции ниже
//   3. Протестируй шаблон на DashboardScreen
//
// МОЙ УНИВЕРСАЛЬНЫЙ ШАБЛОН ПРОМПТА:
// ─────────────────────────────────
// [РОЛЬ]:
// [КОНТЕКСТ ПРОЕКТА]:
// [ЗАДАЧА]:
// [ОГРАНИЧЕНИЯ]:
// [ФОРМАТ]:
// [ПРИМЕРЫ/СТИЛЬ]:
// ─────────────────────────────────
//
// Что нужно реализовать (тест шаблона):
//   DashboardScreen — главный экран дашборда:
//   — приветствие с именем и датой
//   — 4 карточки статистики (2x2 GridView)
//   — последние транзакции (ListView, последние 5)
//   — быстрые действия (Row из 4 круглых кнопок)

class DashboardScreen extends StatelessWidget {
  final String userName;
  const DashboardScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 20 — Финальный проект: Prompt Engineering рефлексия
//
// Оглянись назад на все 20 задач и ответь на вопросы в комментариях.
//
// 1. Средняя оценка точности с первого промпта (⭐ 1–5): ...
//
// 2. Топ-3 техники промптинга которые дали наибольший результат:
//    1) ...
//    2) ...
//    3) ...
//
// 3. Самый эффективный шаблон промпта (скопируй из задачи 19 или улучши):
// ...
//
// 4. Навыки которые улучшились за этот курс:
// ...
//
// 5. Следующие шаги (что изучить дальше):
// ...
//
// Реализуй финальный виджет PortfolioCard — карточка проекта для резюме:
//   — название проекта и описание
//   — стек технологий (chips)
//   — ссылки GitHub / Demo (IconButton)
//   — скриншот (Image.network, aspectRatio 16:9)
//   — анимация при hover (scale 1.02)

class PortfolioCard extends StatefulWidget {
  final String projectName;
  final String description;
  final List<String> techStack;
  final String? githubUrl;
  final String? demoUrl;
  final String? screenshotUrl;

  const PortfolioCard({
    super.key,
    required this.projectName,
    required this.description,
    required this.techStack,
    this.githubUrl,
    this.demoUrl,
    this.screenshotUrl,
  });

  @override
  State<PortfolioCard> createState() => _PortfolioCardState();
}

class _PortfolioCardState extends State<PortfolioCard> {
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
