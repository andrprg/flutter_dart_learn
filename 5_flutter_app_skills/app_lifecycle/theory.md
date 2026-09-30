# Шпаргалка: App Lifecycle

`AppLifecycleState` говорит, видно ли приложение и активно ли оно. Нужен, чтобы сохранять черновик, ставить sync на паузу и не жечь батарею в фоне. Слушают через `WidgetsBindingObserver.didChangeAppLifecycleState`.

Перед задачами прочитай этот файл, затем решай `lifecycle_task.dart`.

## 1. Состояния

| State | Смысл |
|---|---|
| `resumed` | на переднем плане, активно |
| `inactive` | переход / звонок / Control Center — UI может быть виден |
| `paused` | в фоне, кадры не рисуются |
| `hidden` | скрыто (Flutter 3.13+), часто перед paused |
| `detached` | engine отвязан (редко на mobile) |

```dart
bool isForeground(AppLifeState s) => s == AppLifeState.resumed;

bool isUiInvisible(AppLifeState s) =>
    s == AppLifeState.paused ||
    s == AppLifeState.detached ||
    s == AppLifeState.hidden;
```

`inactive` ≠ `paused`: при inactive ещё можно быстро вернуться в resumed без ухода в фон.

## 2. Что делать при переходах

```dart
bool shouldPersistDraft(AppLifeState to) =>
    to == AppLifeState.paused || to == AppLifeState.hidden;

bool shouldPauseSync(AppLifeState to) =>
    to == AppLifeState.paused ||
    to == AppLifeState.detached ||
    to == AppLifeState.hidden;

bool shouldResumeSync(AppLifeState to) => to == AppLifeState.resumed;
```

В `paused`/`hidden`: сохранить черновик на диск, остановить polling/websocket heartbeats. В `resumed`: возобновить sync, обновить данные.

Не полагайся только на `dispose` виджета — при уходе в фон дерево часто **не** уничтожается.

## 3. Observer

```dart
class _HomeState extends State<Home> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    handleLifecycleChange(draftBox, map(state));
  }
}
```

## 4. Валидные переходы (учебная модель)

Типичная цепочка: `resumed → inactive → hidden/paused → … → resumed`.

```dart
// resumed -> inactive
// inactive -> resumed | paused | hidden
// paused -> hidden | resumed | inactive
// hidden -> paused | detached | resumed
// detached -> resumed
```

`LifecycleController.changeTo` при невалидной паре бросает `StateError`.

## 5. State vs restoration

- **Свой save** (prefs/файл) — черновик текста, флаги.
- **RestorationMixin / restorationId** — восстановление UI-стейта после kill процессом ОС.

Оба нужны в серьёзных приложениях; lifecycle говорит *когда* писать.

## 6. Тесты

Гоняй список `LifecycleEvent`: `countResumes`, `backgroundDuration` между `paused` и следующим `resumed`. В widget-тестах — `tester.binding.handleAppLifecycleStateChanged(...)`.

## 7. Что успевает запись

Переход в `paused` — последний спокойный момент записать черновик. ОС может убить процесс в `paused`, не вызвав `dispose` и не дойдя до `detached`. Поэтому сохранение вешают на вход в `paused` / `hidden`, а не на уничтожение виджета.

`inactive` случается часто: шторка уведомлений, входящий звонок, переключатель приложений на части устройств. Писать файл на каждый `inactive` — лишняя работа и гонки. Для черновика достаточно `paused` и `hidden`. Короткий снимок в память можно делать раньше.

`resumed` приходит и после диалога разрешения, и после настоящей паузы. Тяжёлый «обновить всю ленту» на каждый resume сажает сеть и батарею. Отличай долгую паузу (`backgroundDuration` больше порога) от возврата из шторки.

Пока состояние `paused`, кадры не идут, таймеры Flutter могут задерживаться. `Timer.periodic` для синка в фоне ненадёжен и нежелателен. Синк останавливают, чтобы не держать радио. Повтор — на `resumed`.

`AppLifecycleListener` (более новый API) группирует колбэки `onPause` / `onResume` / `onStateChange`. Учебная модель модуля — `WidgetsBindingObserver` и явная таблица переходов. Смысл состояний тот же.

## 8. Восстановление после убийства

Lifecycle не восстанавливает процесс. Если ОС убила приложение, следующий запуск — холодный старт: `main`, потом `resumed`. Черновик должен уже лежать на диске с прошлого `paused`.

`RestorationMixin` и `restorationId` на `RestorationScope` возвращают состояние навигации и полей, которое ОС попросила сохранить (Android сохраняет task). Это другой канал, не твой JSON в prefs. Поле ввода: `RestorableTextEditingController` или ручной save. Свой файл черновика проще отлаживать. Restoration лучше стыкуется с системой, когда убили activity и подняли снова с тем же restoration bucket.

Не сохраняй в черновик токен и чужие персональные данные «заодно». Черновик сообщения — текст и id чата.

Подписка `addObserver` без `removeObserver` в `dispose` оставляет State в списке binding. После закрытия экрана колбэк вызовет `setState` мёртвого State. Один observer на корневой `State` приложения часто лучше, чем копия на каждом экране: иначе N экранов N раз пишут один файл.

## 9. Типичные ошибки

- Считать цепочку всегда `resumed → paused` без `inactive`. Валидатор переходов в задаче это отвергнет.
- Путать `hidden` и `inactive`. `hidden` — UI не виден (Flutter 3.13+), кадры не нужны.
- Запускать websocket только в `initState` и не ставить на паузу. Сокет в фоне держит процесс и батарею.
- Ждать `detached` на телефоне как обычный хук «нас закрыли». На mobile его может не быть перед убийством.
- В тесте забыть, что `handleAppLifecycleStateChanged` не проходит через «невалидные» пары сам: тест задаёт состояния явно.

## 10. Зачем это знать

- paused/hidden — persist + pause network.
- inactive — короткий «полуфон», не всегда пиши на диск агрессивно.
- dispose ≠ уход в фон.
- `hidden` появился позже — учитывай в новых SDK.

Дальше по маршруту: `lifecycle_task.dart` → `interview_questions.md`.
