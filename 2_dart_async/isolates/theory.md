# Шпаргалка: Isolates в Dart

Прочитай перед задачами в `isolates_task.dart`. Isolate — **отдельный isolate с своим heap и event loop**. Общей памяти нет: обмен только сообщениями. Параллельные CPU-задачи — через isolates, не через «потоки с shared state».

## 1. Зачем, если есть async

`async`/`await` **не** снимает нагрузку с UI-потока: долгий синхронный цикл блокирует кадры, таймеры и microtask.

| Уносить в isolate | Оставить на main |
|---|---|
| Тяжёлый JSON, фильтр картинок, crypto, большой `sumSquares` | `setState`, мелкий HTTP, SharedPreferences |
| Ожидаемо **> ~16 ms** на кадр | Короткие операции |

```dart
bool shouldOffloadToIsolate(String workType) =>
    {'json_parse_big', 'image_filter', 'crypto'}.contains(workType);

String chooseRunner({required int expectedMs, int thresholdMs = 16}) =>
    expectedMs > thresholdMs ? 'isolate' : 'main';
```

## 2. `Isolate.run` (и `compute` во Flutter)

Самый простой путь — one-shot:

```dart
Future<int> sumSquaresInIsolate(int n) => Isolate.run(() => sumSquares(n));

Future<List<int>> parseIntListInIsolate(String source) =>
    Isolate.run(() {
      // jsonDecode и т.п. внутри isolate
      return (jsonDecode(source) as List).cast<int>();
    });
```

| API | Где | Смысл |
|---|---|---|
| `Isolate.run` | `dart:isolate` | Создать isolate, выполнить функцию, вернуть Future, убить isolate |
| `compute` | Flutter (`foundation`) | Обёртка над тем же паттерном для UI-кода |

Ошибка внутри `Isolate.run` **пробрасывается** вызывающему как обычный Future error — лови `try/catch` / `.catchError`.

Параллельно по списку:

```dart
Future<List<int>> mapSumSquares(List<int> values) =>
    Future.wait(values.map((n) => Isolate.run(() => sumSquares(n))));
```

## 3. Сообщения: SendPort / ReceivePort

Долгоживущий worker: главный isolate создаёт `ReceivePort`, передаёт `sendPort` в entrypoint, воркер шлёт свой порт обратно, дальше — запросы/ответы.

```dart
class WorkerRequest {
  const WorkerRequest(this.n);
  final int n;
}

class WorkerResponse {
  const WorkerResponse(this.result);
  final int result;
}

void workerEntrypoint(SendPort mainSendPort) {
  final inbox = ReceivePort();
  mainSendPort.send(inbox.sendPort);
  inbox.listen((message) {
    if (message is WorkerRequest) {
      mainSendPort.send(WorkerResponse(sumSquares(message.n)));
    }
  });
}
```

Сценарий `runWorkerOnce`: `Isolate.spawn` → дождаться порта воркера → отправить `WorkerRequest` → получить `WorkerResponse` → `isolate.kill()`.

## 4. Что можно и нельзя передавать

Между isolates копируются (или передаются по правилам sendable) сообщения. Практически:

| Безопасно (идея) | Нельзя / опасно |
|---|---|
| `int`, `double`, `String`, `bool`, `null` | `BuildContext`, виджеты UI |
| `List` / `Map` из sendable значений | Замыкания, захватывающие UI-объекты |
| `SendPort` | Многие «живые» ресурсы (`Socket` как пример из задач) |
| Простые свои классы из полей выше | Объекты с native/plugin-состоянием |

```dart
bool canCaptureUiInIsolateClosure() => false; // нельзя тащить UI в closure для Isolate.run

List<String> isolateSafePayloadTypes() =>
    ['int', 'String', 'List', 'Map', 'SendPort'];

List<String> isolateUnsafePayloadTypes() =>
    ['BuildContext', 'UiWidget', 'Socket'];
```

Замыкание для `Isolate.run` / entrypoint должно быть **top-level или static** (или не захватывать небезопасное). Захват `BuildContext`/контроллеров — типичная ошибка.

## 5. Ошибки и Flutter plugins

- В one-shot: исключение → ошибка Future на вызывающей стороне.
- В worker: лучше слать явный error-message по порту, иначе isolate может умереть молча с точки зрения UI.
- **Plugins** часто привязаны к main isolate: из воркера нельзя напрямую звать большинство platform channels. Считай на воркере, UI/плагины — на main.

## 6. Цена запуска и когда worker окупается

`Isolate.run` каждый вызов: поднять isolate, передать замыкание и аргументы, дождаться результата, убить isolate. На функции в 1 мс накладные расходы дороже работы. Имеет смысл, когда сам расчёт явно тяжелее старта (большой JSON, картинка, криптография) или когда вызовов мало, но каждый блокировал бы кадр.

Долгоживущий worker платит за старт один раз. Дальше сообщения дешевле, но появляются протокол, очередь и `kill` при уходе экрана. Пока запросов единицы — `Isolate.run`. Когда один и тот же разбор идёт пачками — worker.

`Future.wait` из многих `Isolate.run` поднимает много isolate сразу. Это параллелизм по ядрам, пока хватает CPU. Десятки одновременных стартов на слабом телефоне сами становятся лагом. Ограничивай число (пул на 2–4) — в задачах модуля достаточно понимать сам эффект.

Сообщения копируются. Огромный `List` туда и обратно удваивает память на время передачи. Иногда дешевле посчитать на main, чем гонять десятки мегабайт ради миллисекунд CPU.

## 7. Порты и протокол

`ReceivePort` — поток сообщений. Его `sendPort` можно передать в другой isolate. Обратно воркер присылает **свой** `SendPort`. С этого момента есть два направления.

Первое сообщение часто не запрос, а рукопожатие с портом. Пока его не дождался, слать `WorkerRequest` некуда.

Типы сообщений лучше делать своими классами (`WorkerRequest` / `WorkerResponse`), а не голым `int`: иначе не отличить «порт», «результат» и «ошибка». Ошибку тоже шли сообщением: необработанный throw в `listen` воркера роняет isolate, а main висит на `await`, если ждал ответ и не слушает `Isolate.addErrorListener`.

`ReceivePort.close()` нужен, иначе isolate может не завершиться: открытый порт держит его живым. После `kill` всё равно закрой порт на стороне main.

`Isolate.spawn` требует top-level или static entrypoint. Замыкание, захватившее локальную переменную UI, не отправится.

## 8. `compute` и плагины

`compute` во Flutter — тот же one-shot с ограничением: аргумент и результат должны быть sendable, функция — top-level/static. Удобно из виджета, чтобы не тащить `ReceivePort` ради одного JSON.

Platform channel привязан к isolate, где живёт Flutter engine, почти всегда main. Вызов `path_provider` или `shared_preferences` из воркера не работает как на UI. Схема: main читает файл/плагин → байты в isolate → результат обратно → main пишет в плагин.

`BuildContext`, `Element`, контроллеры — не sendable. Ошибка проявляется не всегда понятным `Invalid argument`, а иногда падением при копировании сообщения. В замыкание `Isolate.run` клади только числа, строки, коллекции и свои простые объекты.

## 9. Типичные ошибки

- Унести в isolate `setState` или навигацию.
- Не закрыть `ReceivePort` и получить «приложение не завершается» в консольной задаче.
- Ждать ответ и не обработать смерть воркера — Future висит.
- Считать `async` заменой isolate для цикла на 500 мс.
- Передавать `Map` с ключами-объектами, у которых кривой `hashCode`, или с значениями-сокетами.

## 10. Зачем это знать

- Isolates ≠ threads с shared memory: нет гонок по объектам, есть стоимость копирования сообщений.
- Сначала `Isolate.run` для разовых тяжёлых задач; worker — когда аммортизируешь старт isolate.
- На собесе: когда offload, sendable types, почему нельзя Context, отличие от `compute`.

Дальше: `isolates_task.dart`. После async-модуля — `3_functional_dart_with_fpdart/fpdart/theory.md`.
