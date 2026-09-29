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

## 7. Зачем это знать

- paused/hidden — persist + pause network.
- inactive — короткий «полуфон», не всегда пиши на диск агрессивно.
- dispose ≠ уход в фон.
- `hidden` появился позже — учитывай в новых SDK.

Дальше по маршруту: `lifecycle_task.dart` → `interview_questions.md`.
