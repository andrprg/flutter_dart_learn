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

## 7. Что приходит в приложение

Ссылка может открыть процесс с нуля или прийти в уже живой. На холодном старте URI забирают один раз при инициализации и только потом решают маршрут. Если прочитать ссылку после того, как router ушёл на `/`, пользователь увидит вспышку домашнего экрана.

Пока приложение живо, поток URI (`uriLinkStream` у `app_links` / `uni_links`) даёт следующие ссылки. Подписку отменяют вместе с корневым State. Два слушателя обработают одну ссылку дважды и запушат два экрана.

Нормализация до матча:

- схема и host в нижнем регистре;
- убрать хвостовой `/`, кроме корня;
- `www` и голый домен свести к одному виду, если оба ваши;
- query не считать частью path-паттерна.

`https://example.com/profile/1/` и `/profile/:id` не совпадут, если не срезать слэш. Чужой host `https://evil.com/profile/1` не должен стать экраном профиля только из-за похожего path.

Custom scheme любой приложение может объявить себе. Чужое приложение перехватит `myapp://`. Для перехода из письма и мессенджера нужны HTTPS App Links: файл `assetlinks.json` на домене и intent-filter с `android:autoVerify`, на iOS — Associated Domains и `apple-app-site-association`. Без проверки ОС откроет браузер или спросит, каким приложением открыть.

## 8. Куда девать query и битый путь

Path — ресурс (`/orders/15`). Query — режим (`?pay=1`). Оба попадают в location для go_router. Терять query при сборке `locationOf` — типичный баг «открыли оплату, а параметра нет».

Несовпавший паттерн — не исключение наружу. `matchRoute` возвращает `null`, UI показывает «ссылка устарела» или home. Бросок из парсера роняет холодный старт целиком.

Auth: исходную location кодируют в `redirect`. После логина берут её, только если это **внутренняя** ссылка. Открытый `redirect=https://evil.com` превращает логин в открытый редирект. Разрешай только пути, которые проходят `isAppDeepLink` / начинаются с `/` и не содержат схему.

Один и тот же экран по push-уведомлению и по ссылке должен собираться одной функцией разбора. Иначе payload `event:42` и URL `/events/42` разъедутся.

## 9. Типичные ошибки

- Матчить только path и игнорировать, что ссылка чужого сайта.
- Забыть `Uri.encodeComponent` на параметре, в котором есть `?` или `&`.
- Считать, что universal link работает в debug без association файла. На устройстве откроется Safari/Chrome.
- Перезаписать стек, если та же ссылка пришла повторно (виджет обновился и снова `go`). Сравнивай с текущей location.
- Хранить секрет в query. URL попадает в логи, в историю и в скриншоты шаринга.

## 10. Зачем это знать

- HTTPS links надёжнее custom scheme.
- Path params + query → location для router.
- Auth обязан сохранять intended location.
- Неизвестный path — null/404, не краш.

Дальше по маршруту: `deep_links_task.dart` → `interview_questions.md`.
