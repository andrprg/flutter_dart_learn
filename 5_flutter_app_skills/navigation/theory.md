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

## 7. `go` и `push`: что остаётся в стеке

`go` приводит стек к тому, что описано URL. Переход с `/feed/1` на `/settings` через `go` снимает ленту, а не кладёт настройки сверху. Кнопка Back с настроек не вернёт пост, если его больше нет в стеке.

`push` добавляет маршрут поверх. Back возвращает предыдущий. Для «открыл карточку из списка» — `push`. Для переключения вкладок shell — `go`, иначе каждая вкладка копит историю и Back хаотично прыгает.

`pop` закрывает верхний route и может вернуть значение, как `Navigator.pop(context, result)`. `go` значение родителю не возвращает: это смена location, не диалог.

`context.push` из виджета под `MaterialApp.router` требует `GoRouter` в дереве. Императивный `Navigator.push` рядом с go_router возможен, но этот route **не** попадает в URL. Deep link и обновление страницы на вебе его не восстановят. Для экранов, которыми обмениваются ссылкой, нужен `GoRoute`.

## 8. `redirect` без циклов

`redirect` возвращает `null` — остаться. Возвращает строку — перейти туда. Если новая локация снова редиректит в ту же строку, получится цикл. Условие «уже на login» обязано быть в guard.

`refreshListenable` зовут `redirect` заново, когда у listenable `notifyListeners`. Auth-notifier после логина обязан уведомить, иначе router не узнает, что можно уйти с `/login`. Сам `redirect` не подписывается на `ref.watch`: это колбэк, не `build`.

Порядок: сначала redirect, потом сборка страницы. Тяжёлую сеть внутрь `redirect` не кладут — он синхронный по контракту go_router (можно вернуть `Future`, но долгий guard блокирует навигацию). Проверка «токен есть в памяти» — да. «Сходить на сервер за профилем» — на экране после входа.

`parentNavigatorKey` у вложенного маршрута пробивает shell и кладёт экран на корневой навигатор (полноэкранный логин поверх bottom bar). Без этого login окажется в `child` оболочки с табами.

## 9. Типичные ошибки

- Параметр пути назван `:userId`, а читают `pathParameters['id']` — null и падение на `!`.
- Query не закодирован: `?redirect=/a?x=1` режется. Нужен `Uri.encodeComponent`.
- `extra` как единственный способ передать id. После убийства процесса объекта нет.
- `errorBuilder` забыт — битый path выглядит как пустой экран или исключение в консоли, а не как свой 404.
- Вкладки через `push` и «не работает Back».

## 10. Зачем это знать

- Declarative navigation = URL как источник истины.
- Path — «кто», query — «как показать».
- Redirect + `refreshListenable` — auth и onboarding.
- ShellRoute — общий chrome без дублирования scaffold.
- `errorBuilder` — свой 404 вместо краша.
- Deep link после login: не теряй intended location.

Дальше по маршруту: `go_router_task.dart` → `interview_questions.md`.
