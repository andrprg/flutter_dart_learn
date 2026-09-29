# Шпаргалка: Навигация с go_router

Во Flutter есть два стиля навигации. **Imperative** (`Navigator.push` / `pop`) — «положи экран в стек». **Declarative** (`go_router`) — «URL/состояние описывает, какой стек должен быть». Deep links, auth-guards и web-URL естественно ложатся на declarative.

Перед задачами прочитай этот файл, затем решай `go_router_task.dart`.

## 1. Базовый router

```dart
final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/profile/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        final tab = state.uri.queryParameters['tab'] ?? 'overview';
        return ProfileScreen(id: id, tab: tab);
      },
    ),
  ],
  errorBuilder: (context, state) =>
      RouteErrorScreen(message: state.error.toString()),
);
```

## 2. Path vs query

| Тип | Пример | Смысл |
|---|---|---|
| **Path** | `/profile/:id` | идентичность ресурса |
| **Query** | `?tab=posts` | фильтр, вкладка, опция |

```dart
String readProfileId(GoRouterState state) =>
    state.pathParameters['id']!;

String readProfileTab(GoRouterState state) =>
    state.uri.queryParameters['tab'] ?? 'overview';

String profileLocation(String id, {String tab = 'overview'}) =>
    '/profile/$id?tab=$tab';
```

## 3. Redirect и auth

`redirect` — guard: куда пускать пользователя. `refreshListenable` пересчитывает redirect при смене auth.

```dart
GoRouter(
  refreshListenable: authState,
  redirect: (context, state) {
    final loggingIn = state.matchedLocation == '/login';
    if (!authState.isLoggedIn && !loggingIn) return '/login';
    if (authState.isLoggedIn && loggingIn) return '/';
    return null; // ок, остаёмся
  },
  routes: [ /* ... */ ],
);
```

Типичный баг deep link + redirect: затереть intended URL. Сохраняй `?redirect=...` и верни пользователя после login.

## 4. ShellRoute и вкладки

`ShellRoute` держит общий scaffold (bottom nav / rail), а дочерние маршруты меняют только `child`:

```dart
ShellRoute(
  builder: (context, state, child) =>
      BottomNavigationScaffold(child: child),
  routes: [
    GoRoute(path: '/feed', builder: (_, __) => const FeedScreen()),
    GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
  ],
);
```

Переключение вкладок — `context.go('/feed')`, не `push`: иначе стек раздувается.

## 5. `extra` vs URL

```dart
context.go('/article', extra: article);

// на экране:
final article = state.extra as Article;
```

- **path/query** — сериализуются в URL, переживают deep link и refresh.
- **extra** — объект в памяти; при cold start по ссылке его не будет.

## 6. Навигация из UI

```dart
context.go('/profile/42?tab=posts'); // заменить location
context.push('/login');               // положить сверху
context.pop();                        // назад
```

## 7. Зачем это знать

- Declarative navigation = URL как источник истины.
- Path — «кто», query — «как показать».
- Redirect + `refreshListenable` — auth и onboarding.
- ShellRoute — общий chrome без дублирования scaffold.
- `errorBuilder` — свой 404 вместо краша.
- Deep link после login: не теряй intended location.

Дальше по маршруту: `go_router_task.dart` → `interview_questions.md`.
