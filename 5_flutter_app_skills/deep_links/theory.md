# Шпаргалка: Deep Links

Deep link открывает конкретный экран приложения по URI. **Custom scheme** (`myapp://profile/1`) проще настроить, но менее безопасен. **HTTPS App Links / Universal Links** (`https://example.com/profile/1`) проверяются ОС через Digital Asset Links / apple-app-site-association — предпочтительнее.

Перед задачами прочитай этот файл, затем решай `deep_links_task.dart`. Хорошо стыкуется с `navigation/` (go_router).

## 1. Распознать ссылку приложения

```dart
bool isAppDeepLink(Uri uri) {
  if (uri.scheme == 'myapp') return true;
  if (uri.scheme == 'https' &&
      (uri.host == 'example.com' || uri.host == 'www.example.com')) {
    return true;
  }
  return false;
}
```

## 2. Парсинг в AppLink

```dart
AppLink parseAppLink(Uri uri) => AppLink(
  scheme: uri.scheme,
  host: uri.host,
  path: uri.path.isEmpty ? '/' : uri.path,
  queryParams: uri.queryParameters,
);

String locationOf(AppLink link) {
  if (link.queryParams.isEmpty) return link.path;
  return Uri(path: link.path, queryParameters: link.queryParams).toString();
}
```

Нормализация: убери хвостовой `/` (кроме корня) перед матчем.

## 3. Pattern matching

Шаблоны: `/profile/:id`, `/products/:id`. Сегмент `:name` → path param.

```dart
Map<String, String>? matchPathParams(String pattern, String path) {
  final pSeg = patternSegments(pattern);
  final aSeg = patternSegments(path); // те же правила нарезки
  if (pSeg.length != aSeg.length) return null;
  final params = <String, String>{};
  for (var i = 0; i < pSeg.length; i++) {
    if (pSeg[i].startsWith(':')) {
      params[pSeg[i].substring(1)] = aSeg[i];
    } else if (pSeg[i] != aSeg[i]) {
      return null;
    }
  }
  return params;
}
```

`matchRoute` — первый подходящий из `routePatterns`, иначе `null` (невалидный deep link → fallback home / error).

## 4. Auth + redirect

Публичные: `login`, `resetPassword`. Остальные требуют логин:

```dart
bool requiresAuth(String routeName) => !publicRoutes.contains(routeName);

String loginRedirectLocation(String intended) =>
    '/login?redirect=${Uri.encodeComponent(intended)}';

String postLoginLocation(AppLink loginLink) =>
    loginLink.queryParams['redirect'] ?? '/';
```

Типичный баг: открыли deep link → redirect на login → **потеряли** intended URL. Всегда прокидывай `redirect`.

## 5. go_router и платформы

В go_router входящий URI матчится на `GoRoute.path`; guards — в `redirect`. На Android: intent-filters + assetlinks.json. На iOS: Associated Domains. Custom scheme — в манифесте / Info.plist.

## 6. Тесты

Чистые функции: `isAppDeepLink`, `matchPathParams`, `resolveDeepLink` — без UI. Кейсы: trailing slash, query, чужой host, auth redirect.

## 7. Зачем это знать

- HTTPS links надёжнее custom scheme.
- Path params + query → location для router.
- Auth обязан сохранять intended location.
- Неизвестный path — null/404, не краш.

Дальше по маршруту: `deep_links_task.dart` → `interview_questions.md`.
