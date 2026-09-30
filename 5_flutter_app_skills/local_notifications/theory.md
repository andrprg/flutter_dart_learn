# Шпаргалка: Локальные уведомления

**Local** — приложение само показывает или планирует уведомление на устройстве. ОС хранит его и может показать, даже если процесс уже не на экране. **Push** — сервер шлёт сообщение через FCM (Android и часто iOS) или APNs (iOS), а система доставляет его на устройство. Модуль про локальные: каналы Android, category/actions iOS, payload, permissions и сервис-обёртка без привязки к плагину.

Перед задачами прочитай этот файл, затем решай `notifications_task.dart`.

Локальное и push часто живут вместе. Data-сообщение FCM приходит в приложение, а баннер рисует уже локальный плагин — с твоим каналом, кнопками и payload. Путать их нельзя: у push другие токены, сервер и доставка, у local — каналы, расписание и показ из кода. Токен, виды сообщений и состояния foreground / background / terminated — модуль `push_notifications/`.

## 1. Из чего состоит уведомление

| Поле | Зачем |
|---|---|
| `id` (`int`, `>= 0`) | Идентификатор в системе. Тот же id **заменяет** уже показанное, а не плодит копию |
| `title` / `body` | Текст баннера. Пустые строки в задаче — ошибка |
| `payload` | Строка контекста для тапа и кнопок: куда перейти, какой объект открыть |
| `actions` | Кнопки. Один и тот же `action.id` на Android и iOS |
| канал / category | Куда ОС «кладёт» уведомление: звук, важность, набор кнопок |

```dart
const ShowNotificationRequest(
  id: 7,
  title: 'Новое событие',
  body: 'Подтвердите участие',
  payload: 'event:42',
  actions: [NotificationAction(id: 'confirm', title: 'Подтвердить')],
);
```

Плагин (`flutter_local_notifications` и аналоги) почти всегда отдаёт payload **одной строкой**. Сложный объект кодируй сам (`event:42`, JSON), но держи строку короткой: это не место для файла или секрета. Payload виден в логах и в дампе уведомления.

## 2. Android channel

С Android 8 (API 26) каждое уведомление обязано идти в **channel**. Канал — это пользовательская настройка: имя, описание, важность, звук, вибрация, badge. Пользователь может заглушить канал в системных настройках, и приложение это не перебьёт следующим `show()`.

```dart
AndroidChannelConfig createWebsocketChannel() => const AndroidChannelConfig(
  id: 'websocket_events',
  name: 'WebSocket events',
  description: 'Notifications received from WebSocket',
  importance: NotificationImportance.high,
);

bool isHeadsUpChannel(AndroidChannelConfig c) =>
    c.importance == NotificationImportance.high;
```

| Importance | Что видит человек |
|---|---|
| `low` | Строка в шторке, без звука и без всплывающего баннера |
| `defaultImportance` | Звук и иконка в статус-баре, обычно без heads-up |
| `high` | Heads-up: баннер поверх текущего экрана + звук |

В учебной модели heads-up — только `high`. На реальном Android то же делают `Importance.high` и `Importance.max`. `min` (его в задаче нет) почти прячет уведомление: ни звука, ни иконки.

Практические правила:

- `id` канала — стабильный контракт. По нему система помнит выбор пользователя. Новый смысл — новый id, а не правка старого.
- `name` и `description` видны в настройках. Пиши их для человека, не `channel_1`.
- Канал создают **до** первого `show` на этот id. Иначе на Android 8+ уведомление может молча не появиться.
- Важность, заданную при создании, система почти не даёт поднять из кода. Пользователь уже мог её снизить. Смена `importance` в новой версии приложения старый канал не обновляет.
- Звук и вибрация с Android 8 живут на канале, а не на каждом уведомлении. «Тихий чат» и «срочные события» — два канала, не два флага в одном `show`.
- Один канал на одну причину шума. Сваливать чаты, маркетинг и ошибки в `default` — значит пользователь выключит всё сразу.

## 3. iOS category и actions

На iOS кнопки живут в **category** (`UNNotificationCategory`). Уведомление ссылается на category id, а система подставляет зарегистрированные кнопки. Категорию регистрируют при инициализации, не в момент показа.

```dart
NotificationAction createConfirmAction() =>
    const NotificationAction(id: 'confirm', title: 'Подтвердить');

String iosWebsocketCategoryId() => 'websocket_event';
```

Один `action.id` держи кроссплатформенно: Android action и iOS action с id `confirm` попадают в один обработчик. Заголовок кнопки (`Подтвердить`) — только UI.

На iOS у действия бывают флаги, которых в учебной модели нет, но на собеседовании их ждут:

- открыть приложение (foreground) или обработать в фоне;
- destructive — красная кнопка «Удалить»;
- authenticationRequired — сначала Face ID / пароль.

Тап по **телу** баннера — это действие по умолчанию, не твоя кнопка. Смахивание — отдельное событие dismiss, его не путай с `confirm`.

## 4. Tap vs action

```dart
NotificationInteractionType interactionTypeFrom(String? actionId) =>
    (actionId == null || actionId.isEmpty)
        ? NotificationInteractionType.tap
        : NotificationInteractionType.action;

NotificationResponse buildResponse({String? actionId, String? payload}) {
  return NotificationResponse(
    type: interactionTypeFrom(actionId),
    actionId: actionId,
    payload: payload,
  );
}

bool shouldHandleAction(NotificationResponse response) =>
    response.type == NotificationInteractionType.action;
```

Две ветки UX:

| Жест | Тип | Что делать |
|---|---|---|
| Тап по телу | `tap` | Открыть экран по payload. `onAction` **не** звать |
| Тап по кнопке | `action` | `onAction(actionId, payload)` — подтвердить, ответить, отложить |

`shouldHandleAction` истинен только для `action`. Пустой `actionId` и `null` — оба tap: плагин так помечает нажатие на тело, когда отдельной кнопки не было.

## 5. Payload

Payload связывает баннер с сущностью. Без него тап открывает приложение «в никуда».

```dart
String eventPayload(String eventId) => 'event:$eventId';

String? parseEventId(String? payload) {
  if (payload == null || !payload.startsWith('event:')) return null;
  final id = payload.substring('event:'.length);
  if (id.isEmpty) return null;
  return id;
}
```

В задаче достаточно префикса `event:`. На практике проверяй и пустой хвост: `event:` — битый payload, навигации по нему нет.

Дальше по коду приложения: `parseEventId` → `context.go('/events/$id')` или аналог. Ошибка формата — остаться на текущем экране, а не падать. Тап и кнопка читают **одну и ту же** строку: кнопка «Подтвердить» у события 42 несёт `event:42`, а не отдельный секретный id.

Не клади в payload токены и персональные данные. Для навигации хватает стабильного id.

## 6. Сервис: initialize → show → handleResponse

Плагин и обёртка живут дольше одного экрана. Показ до инициализации и обработка тапа «как получится» — типичный баг джуна.

```dart
void validateShowRequest(ShowNotificationRequest r) {
  if (r.title.isEmpty || r.body.isEmpty || r.id < 0) {
    throw ArgumentError('invalid notification request');
  }
}

class NotificationService {
  NotificationService({required this.onAction});

  final NotificationActionHandler onAction;
  bool isInitialized = false;
  final List<ShowNotificationRequest> shown = [];

  Future<void> initialize() async {
    isInitialized = true;
  }

  Future<void> show(ShowNotificationRequest request) async {
    if (!isInitialized) {
      throw StateError('NotificationService is not initialized');
    }
    validateShowRequest(request);
    shown.add(request);
  }

  Future<void> handleResponse(NotificationResponse response) async {
    if (!shouldHandleAction(response)) return;
    final actionId = response.actionId;
    if (actionId == null || actionId.isEmpty) return;
    await onAction(actionId, response.payload);
  }
}
```

Контракт задачи:

- `initialize()` ставит `isInitialized = true`. В проде здесь же: регистрация плагина, каналов и iOS categories.
- `show()` до `initialize` бросает `StateError`.
- `show()` гоняет запрос через `validateShowRequest`: пустой title/body или `id < 0` → `ArgumentError`.
- `handleResponse()` зовёт `onAction` только для action-кнопок. Tap список `handled` не пополняет.

Порядок в `main`:

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final service = NotificationService(onAction: handleConfirm);
  await service.initialize();
  runApp(const App());
}
```

`WidgetsFlutterBinding.ensureInitialized()` нужен до любого плагина, который трогает каналы платформы. Каналы создают внутри `initialize`, не перед первым случайным `show` с экрана.

Фоновый callback плагина (тап, когда изолят UI не активен) обязан быть **top-level** функцией, не замыканием и не методом объекта. Иначе ОС не сможет его вызвать. Помечают `@pragma('vm:entry-point')`, чтобы tree-shaking его не вырезал.

Если приложение было убито и пользователь открыл его тапом по баннеру, ответ не придёт в обычный listener. Его забирают при старте (`getNotificationAppLaunchDetails` у `flutter_local_notifications`): флаг «запущены из уведомления» + payload. Эту ветку легко забыть — и cold start открывает домашний экран вместо события.

## 7. Permissions

Без разрешения показ «успешен» в коде, а баннера нет.

| Платформа | Что просить |
|---|---|
| Android 13+ (API 33) | runtime `POST_NOTIFICATIONS`. Раньше уведомления были разрешены после установки |
| iOS | `alert`, `badge`, `sound` через `UNUserNotificationCenter` |

```dart
List<String> requiredNotificationPermissions() =>
    ['alert', 'badge', 'sound'];
```

Запрашивай **перед** первым полезным уведомлением, с rationale: своим экраном «зачем», потом системный диалог. Общий модуль permissions: статус `denied` → можно спросить снова; `permanentlyDenied` → только настройки, повторный request бесполезен. На Android 13 отказ `POST_NOTIFICATIONS` как раз уводит в этот сценарий.

На iOS есть ещё provisional (тихие уведомления в Центр уведомлений без диалога) и critical alerts (особые entitlement). В задаче их нет: нужны обычные alert / badge / sound.

Проверяй разрешение и при возврате из настроек: пользователь мог включить тумблер, статус в памяти приложения сам не обновится.

## 8. Foreground

Приложение на экране и приложение в шторке — разные политики.

- **iOS** по умолчанию **не** показывает баннер, звук и badge, пока приложение в foreground. Это решает delegate `willPresent`. В плагине те же флаги: `presentBanner` / `presentAlert`, `presentList`, `presentSound`, `presentBadge`. Без них событие приходит в код, а человек ничего не видит.
- **Android** чаще показывает уведомление и в foreground. Решает importance канала, не отдельный «foreground flag». Heads-up всё равно требует `high` и не заглушенный канал. Не мешай пользователю, если он уже смотрит тот же чат: такое уведомление лучше не слать.

Foreground presentation и permission — разные вещи. Разрешение даёт право вообще уведомлять. Presentation решает, всплывать ли баннеру, когда UI уже открыт.

## 9. Когда уведомление реально всплывёт

| Способ | Кто показывает | Процесс приложения |
|---|---|---|
| `show()` сейчас | плагин → ОС | должен быть жив в момент вызова |
| `zonedSchedule` / периодическое | ОС в заданное время | может быть убито: будильник уже у системы |
| Push | FCM / APNs | может быть убито; показ делает система или твой local-код на data-message |

«Поставить таймер в Dart и через `Future.delayed` вызвать `show`» не переживает смерть процесса. Для напоминания нужен schedule в ОС (и пакет `timezone` для корректной зоны). Точный будильник на Android 12+ упирается в `SCHEDULE_EXACT_ALARM` / `USE_EXACT_ALARM`; неточный schedule бережёт батарею и для большинства напоминаний достаточен.

Пока приложение `paused`, локальный показ из живого изолята ещё возможен. Когда процесс убит, остаётся только то, что уже отдано системе: запланированное уведомление или push.

## 10. Local не отключает push

Локальный `show` не рвёт доставку FCM и APNs: сообщение по-прежнему приходит на устройство. Пропадает баннер, потому что разрешение, канал Android и центр уведомлений iOS у local и push общие.

| Что общее | Как local прячет push |
|---|---|
| Разрешение | Отказ `POST_NOTIFICATIONS` (Android 13+) или `alert` / `badge` / `sound` (iOS) глушит оба вида. Диалог один на приложение |
| `channel id` | Канал, в который FCM кладёт notification-сообщение (`channel_id` в payload или `default_notification_channel_id` в манифесте), создан локальным кодом с низкой важностью — пуш останется тихой строкой. Важность первого создания система почти не поднимает. Удалённый канал: Android отбрасывает уведомление в несуществующий id |
| Числовой `id` | Тот же id заменяет уже показанный баннер. Следующие пуши из-за этого не отключаются |
| `UNUserNotificationCenter` | На iOS оба плагина садятся на один delegate. Ошибочный порядок инициализации ломает тап и показ в foreground, не саму доставку |

Два пути FCM, из шпаргалки выше:

- **Notification-сообщение** в фоне рисует система. Локальный `show` в этот путь не входит. Баннера нет из-за разрешения, заглушённого или удалённого канала, либо потому что карточку сразу заменили уведомлением с тем же id.
- **Data-сообщение** само баннер не рисует — его показывает локальный плагин. Нет канала, `initialize`, разрешения или iOS foreground-флагов (`presentBanner` / `presentAlert`) — в коде сообщение есть, человек ничего не видит.

## 11. Id, отмена, группы

- Один логический объект — один id. Новое сообщение в чате 7 обновляет уведомление 7, а не добавляет восьмое.
- `id < 0` в задаче запрещён. Ноль допустим.
- Отмена по id снимает баннер и отменяет schedule с тем же id.
- Много однотипных уведомлений группируют (Android group / inbox, iOS thread identifier), чтобы шторка не превращалась в простыню. Группа не заменяет канал: канал — про звук и право пользователя, группа — про пачку в шторке.

## 12. Типичные провалы

- Канал не создан или создан после `show`.
- Важность подняли в коде, а пользовательский канал со старым id остался тихим.
- Tap обработали как action и вызвали «Подтвердить» просто за открытие экрана.
- Payload без префикса или с секретом; `parseEventId('bad')` должен вернуть `null`, не бросать.
- Инициализация в первом экране, а тап по уведомлению пришёл на cold start раньше `runApp`.
- Background-callback — метод виджета. На изоляте его нет.
- На iOS забыли foreground presentation и решили, что `show` сломан.
- На Android 13 не запросили `POST_NOTIFICATIONS` и не положили его в манифест.
- Канал FCM создали из локального кода с низкой важностью или удалили — notification-пуш молчит, хотя токен и сервер в порядке.
- Data-пуш ждали как системный баннер и не вызвали локальный `show`.

## 13. Как проверять без устройства

Логику каналов, payload и ветки tap/action гоняют обычным тестом на `NotificationService`, без плагина. Это как раз `notifications_task_test.dart`.

На устройстве отдельно смотрят то, чего нет в модели:

- канал после первого запуска нельзя «починить» сменой `importance` в коде — только новый `id` или ручное включение в настройках;
- запрет `POST_NOTIFICATIONS` выглядит как успешный `show` в старых обёртках плагина;
- тап по баннеру при убитом процессе попадает в `getNotificationAppLaunchDetails`, а не в слушатель, подписанный на секунду позже;
- iOS в foreground молчит, пока не включены `presentBanner` / `presentSound`.

Лог «show вызван» не доказывает, что баннер был на экране.

## 14. Зачем это знать

- Local и push решают разные задачи; баннер из data-push всё равно часто рисуют локальным API. Local доставку пуша не отключает, но общее разрешение и канал Android могут спрятать баннер.
- Канал Android обязателен с API 26, и пользователь им владеет.
- Category iOS — это набор кнопок, а не «ещё один channel».
- Payload связывает уведомление с навигацией; tap и action — разные ветки.
- Без permission, initialize и (на iOS) foreground-флагов показа не будет, даже если `show()` не бросил ошибку.

Дальше по маршруту: `notifications_task.dart` → `interview_questions.md`.
