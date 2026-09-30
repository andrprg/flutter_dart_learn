# Шпаргалка: Push-уведомления

**Push** — сервер доставляет сообщение на устройство через FCM. FCM на Android говорит с устройством сам, на iOS передаёт показ в APNs. **Local** — процесс сам просит ОС показать баннер. Этот модуль про серверный путь: токен, вид payload, состояние процесса и обработчики. Показ баннера из кода — модуль `local_notifications/`. Маршрут из payload стыкуется с `deep_links/`.

Перед задачами прочитай этот файл, затем решай `push_task.dart`. Задачи моделируют поведение `firebase_messaging` обычным Dart, без плагина и Firebase-проекта.

## 1. Цепочка доставки

1. Приложение получает **registration token** и отправляет его на свой бэкенд вместе с id пользователя.
2. Бэкенд хранит токен и в нужный момент вызывает FCM HTTP v1.
3. FCM доставляет сообщение. На iOS видимый баннер всё равно рисует APNs.
4. Приложение реагирует по состоянию процесса: `onMessage`, системный трей, `onBackgroundMessage` или тап.

Токен — адрес **установки приложения на конкретном устройстве**, не адрес пользователя. Переустановка, очистка данных и иногда обновление системы выдают новый токен. Один пользователь — несколько токенов, если у него несколько устройств.

## 2. Токен

На бэкенд уходит только непустая строка без пробелов. Реальный токен длинный; в задаче достаточно этой проверки.

```dart
bool isValidFcmToken(String? token) {
  if (token == null) return false;
  final value = token.trim();
  if (value.isEmpty) return false;
  return !RegExp(r'\s').hasMatch(value);
}

bool shouldUploadToken({String? previous, required String? next}) {
  if (!isValidFcmToken(next)) return false;
  if (!isValidFcmToken(previous)) return true;
  return previous!.trim() != next!.trim();
}
```

Повторно слать тот же токен не нужно. Новый — нужно: старый адрес FCM больше не доставит сообщение этому приложению.

```dart
class DeviceTokenRegistry {
  String? token;
  bool synced = false;

  bool get needsSync => isValidFcmToken(token) && !synced;

  void onTokenRefresh(String? raw) {
    if (!isValidFcmToken(raw)) {
      throw ArgumentError('invalid fcm token');
    }
    final next = raw!.trim();
    if (token == next) return;
    token = next;
    synced = false;
  }

  void markSynced() {
    if (!isValidFcmToken(token)) {
      throw StateError('nothing to sync');
    }
    synced = true;
  }

  void onLogout() {
    token = null;
    synced = false;
  }
}
```

В проде рядом с `onLogout` делают две вещи. Бэкенд удаляет связку «этот пользователь — этот токен», иначе следующий аккаунт на том же телефоне получит чужие сообщения. Клиент вызывает `deleteToken`, чтобы FCM перестал считать установку получателем старых рассылок.

На iOS `getToken()` часто возвращает `null`, пока не пришёл APNs-токен. Рабочий источник — стрим `onTokenRefresh`: первый валидный токен и все следующие уходят в `onTokenRefresh`. Подписку на стрим вешают один раз при старте.

Разрешение на показ и токен — разное. Токен можно получить и без права показывать баннер. Без `POST_NOTIFICATIONS` (Android 13+) и без iOS alert пользователь notification-сообщение не увидит.

## 3. Три вида сообщений

| Вид | Что лежит в payload | Кто рисует баннер, когда приложение не на экране |
|---|---|---|
| `notification` | `title` / `body`, data пустой | Система (FCM / APNs). Dart при получении не вызывается |
| `data` | только карта `data` | Никто. Код сам решает, нужен ли баннер |
| `both` | и текст, и `data` | Система рисует текст. `data` доступна обработчику |

```dart
PushMessageKind messageKind(RemotePushMessage message) {
  bool hasText(String? value) => value != null && value.trim().isNotEmpty;

  final hasNotification = hasText(message.title) || hasText(message.body);
  final hasData = message.data.isNotEmpty;
  if (hasNotification && hasData) return PushMessageKind.both;
  if (hasNotification) return PushMessageKind.notification;
  if (hasData) return PushMessageKind.data;
  throw ArgumentError('push has neither notification nor data');
}
```

Значения в `data` — строки. Числа и bool на бэкенде тоже кодируют строкой и разбирают уже в приложении.

Учебная модель для `both` вне экрана: трей показывает ОС, data приходит в background-handler. На Android это обычный путь. На iOS data в killed-состоянии часто доезжает только вместе с тапом (`getInitialMessage`), если в payload нет `content-available`. На собеседовании эту разницу проговаривают отдельно: контракт задачи один, платформы доставляют data с разной надёжностью.

## 4. Состояние процесса

| Состояние | Что это | Куда попадает сообщение |
|---|---|---|
| `foreground` | пользователь в приложении | всегда `onMessage` |
| `background` | процесс жив, UI не на экране | зависит от вида |
| `terminated` | процесс убит | зависит от вида; тап — отдельный вход |

```dart
PushArrival arrivalPlan(PushMessageKind kind, PushAppState state) {
  if (state == PushAppState.foreground) return PushArrival.onMessage;
  return switch (kind) {
    PushMessageKind.notification => PushArrival.systemTray,
    PushMessageKind.data => PushArrival.backgroundHandler,
    PushMessageKind.both => PushArrival.systemTrayAndBackground,
  };
}
```

`systemTray` значит: баннер уже у системы, вашего Dart-кода в момент доставки нет. Логика «прочитали сообщение» начнётся только после тапа.

## 5. Тап

Тап по баннеру и момент доставки — разные события.

```dart
PushTapSource? tapSource(PushAppState state) {
  return switch (state) {
    PushAppState.foreground => null,
    PushAppState.background => PushTapSource.openedApp,
    PushAppState.terminated => PushTapSource.initialMessage,
  };
}
```

| Состояние до тапа | API `firebase_messaging` |
|---|---|
| background | стрим `onMessageOpenedApp` |
| terminated | один раз `getInitialMessage()` |
| foreground | системного тапа нет: вы уже в `onMessage` |

`getInitialMessage()` зовут после `Firebase.initializeApp()`, до навигации. `null` — обычный запуск. Забыли дождаться future — холодный старт открывает домашний экран, а заказ из пуша теряется. Стрим `onMessageOpenedApp` подписывают там же, в `main`, до `runApp`: поздний `listen` пропускает тап, который уже случился.

Оба входа читают одну и ту же `data` и идут в один роутер.

## 6. Кто рисует баннер

В foreground система баннер не показывает. Сообщение приходит в `onMessage`, и если нужен видимый alert, его рисует локальный плагин — со своим каналом, кнопками и payload.

```dart
bool systemShowsBanner(PushMessageKind kind, PushAppState state) {
  if (state == PushAppState.foreground) return false;
  return kind != PushMessageKind.data;
}
```

| kind | foreground | background / terminated |
|---|---|---|
| notification, both | баннер рисуете вы (`local_notifications`) | баннер рисует система |
| data | тихая доставка в `onMessage` | тихая доставка в background-handler |

Data-only само по себе молчит. Это синк, инвалидация кэша, «обнови счётчик». Видимый баннер из data — уже ваш `show()` локального плагина, с каналом Android и permission.

На Android 8+ системный показ notification-сообщения требует канал. Его id кладут в манифест:

`com.google.firebase.messaging.default_notification_channel_id`

Канал с этим id создают при старте. Иначе фоновый notification-push на Android 8+ может не появиться, хотя FCM сообщение принял. Канал создаёт локальный плагин — связь двух модулей прямая.

На iOS есть `setForegroundNotificationPresentationOptions` (banner, sound, badge): ОС сама покажет notification, пока приложение открыто. Учебный контракт всё равно считает foreground «баннер рисует приложение»: так один код покрывает Android и iOS и даёт свои action-кнопки.

## 7. Background-handler

Обработчик data вне экрана работает в отдельном изоляте. Там нет виджетов, `BuildContext` и вашего Provider, поднятого в UI-изоляте.

```dart
bool canRegisterBackgroundHandler({
  required bool isTopLevelOrStatic,
  required bool isAnonymous,
  required bool registeredBeforeRunApp,
}) {
  return isTopLevelOrStatic && !isAnonymous && registeredBeforeRunApp;
}
```

Три условия сразу:

- функция top-level или `static` — замыкание и метод объекта изолят не вызовет;
- функция не анонимная;
- `FirebaseMessaging.onBackgroundMessage(...)` стоит в `main` **до** `runApp`.

В файле обработчик помечают `@pragma('vm:entry-point')`, иначе tree shaking вырежет его из release. Внутри первым делом `WidgetsFlutterBinding.ensureInitialized()` и `Firebase.initializeApp()`: этот изолят стартует с нуля. Плагины, которые нужны для `show()` локального уведомления, инициализируют здесь же, а не надеются на `main` UI-изолятора.

## 8. Маршрут из data

```dart
String? routeFromData(Map<String, String> data) {
  final explicit = data['route'];
  if (explicit != null && explicit.startsWith('/')) return explicit;

  final type = data['type'];
  final id = data['id'];
  if (type == null || id == null || id.isEmpty) return null;
  return switch (type) {
    'chat' => '/chat/$id',
    'order' => '/orders/$id',
    _ => null,
  };
}
```

Явный `route` с ведущим `/` побеждает `type` + `id`. Неизвестный type даёт `null`: остаётесь на текущем экране, приложение не падает. Дальше строку можно отдать в go_router. Разбор чужого URI — модуль deep links; здесь маршрут уже внутренний.

В data нет токенов сессии, паролей и полных персональных карточек. Payload виден в логах, в дампе уведомления и на бэкенде пуш-провайдера. Для навигации хватает id.

## 9. Повторы, collapse, priority

FCM имеет право доставить одно и то же сообщение дважды. `messageId` фильтруют до навигации и до побочных эффектов.

```dart
class PushDeduper {
  final Set<String> seen = {};

  bool accept(String messageId) {
    if (messageId.isEmpty) return false;
    return seen.add(messageId);
  }
}
```

`collapseKey` схлопывает очередь на устройстве: у чата остаётся последняя реплика, а не десять баннеров. В модели последнее сообщение с тем же непустым ключом встаёт на место первого. Пустой ключ и `null` не объединяются.

```dart
List<RemotePushMessage> collapseTray(List<RemotePushMessage> incoming) {
  final visible = <RemotePushMessage>[];
  final indexByKey = <String, int>{};

  for (final message in incoming) {
    final key = message.collapseKey;
    if (key == null || key.isEmpty) {
      visible.add(message);
      continue;
    }
    final index = indexByKey[key];
    if (index == null) {
      indexByKey[key] = visible.length;
      visible.add(message);
    } else {
      visible[index] = message;
    }
  }
  return visible;
}
```

`PushPriority.high` будит устройство и обходит часть батчинга Doze — для чата и звонка. `normal` система может отложить — для дайджеста и маркетинга. Высокий приоритет на рассылку «скидка дня» сажает батарею и упирается в квоты FCM: такие сообщения понижают или отбрасывают.

## 10. Топики

Топик — подписка установки на строковое имя (`news`, `orders`). Сервер шлёт одно сообщение в топик, FCM фанаутит его по подписчикам. Так рассылают новости. Личное («ваш заказ 18») шлют по токену устройства, не по топику.

```dart
bool isValidTopic(String topic) {
  return RegExp(r'^[A-Za-z0-9\-_.~%]{1,900}$').hasMatch(topic);
}
```

Имя — 1..900 символов из латиницы, цифр и `-_.~%`. `'/topics/news'` — путь HTTP API, в `subscribeToTopic` его не передают. Подписываются после того, как токен уже есть.

## 11. Платформы

| | Android | iOS |
|---|---|---|
| Конфиг | `google-services.json`, плагин Google Services | Push capability, Background Modes → remote notifications, APNs Auth Key (.p8) в консоли Firebase |
| Показ | канал с id из манифеста, `POST_NOTIFICATIONS` с API 33 | разрешение alert / badge / sound |
| Фон | data стабильно будит background-handler | data — best effort, часто нужен `content-available` |

Порядок старта:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(const App());
}
```

Разрешение спрашивают в контексте («включите, чтобы не пропустить ответ»), затем берут токен и отправляют его на бэкенд. Общий модуль permissions: `permanentlyDenied` ведёт в настройки, повторный request пустой.

## 12. Типичные провалы

- Токен сохранили локально и не отправили на бэкенд. Пушить некуда.
- После logout связку на сервере оставили. Чужой аккаунт получает чужие заказы.
- `onTokenRefresh` не слушают. Токен сменился — доставка умерла молча.
- Notification-сообщение ждут в Dart, пока приложение в фоне. Код не вызовется, баннер уже у системы.
- Background-handler — метод виджета или замыкание. В release его нет, в изоляте он не вызывается.
- Регистрацию handler поставили после `runApp`.
- Внутри handler трогают Provider UI-изолятора.
- Cold start не ждёт `getInitialMessage`.
- Foreground: сообщение пришло в `onMessage`, баннер забыли нарисовать локально.
- Канал по умолчанию не создан — Android 8+ молчит на системном notification-push.
- В data положили access token.
- Маркетинг отправили с priority high.
- Повторный `messageId` открыл тот же экран второй раз.

## 13. Как отлаживать доставку

Смотри по порядку, не с сервера сразу:

1. В приложении токен непустой и ушёл на бэкенд (`synced`).
2. На бэкенде токен принадлежит текущему пользователю, старые сняты на logout.
3. В консоли Firebase тестовое сообщение на этот токен. Если его нет на устройстве — дело не в твоём JSON, а в токене, разрешении или конфиге платформы.
4. Если консоль показывает баннер, а твой сервер нет — сравни вид сообщения и канал.
5. Если баннер есть, а экран не открывается — смотри cold start и `messageId`, который обработали дважды.

Data-сообщение в фоне нечем «увидеть» без лога в background-handler. Лог из обычного `print` виджета в этот момент не из того изолята.

Повторная отправка того же `messageId` должна быть идемпотентной: второе открытие экрана не создаёт вторую покупку. Храни id обработанных сообщений хотя бы в памяти сессии.

## 14. Зачем это знать

- Push доставляет сервер, local рисует баннер из процесса. В foreground они встречаются.
- Токен привязан к установке. Его обновляют и отзывают на logout.
- Вид сообщения и состояние процесса выбирают callback. Тап — отдельная ветка: `onMessageOpenedApp` или `getInitialMessage`.
- Data — тихий канал. Секретам и навигации «в никуда» в ней не место.
- Background-handler — отдельный изолят со своими правилами регистрации.

Дальше по маршруту: `push_task.dart` → `interview_questions.md`.
