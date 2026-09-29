# Ответы: Isolates

**1.** Isolates не делят память → без data races. Общение через сообщения (SendPort/ReceivePort).

**2.** CPU-тяжёлое: большой JSON, image processing, crypto. Не для микро-задач (накладные расходы).

**3.** Оба запускают one-shot функцию в isolate. `compute` — Flutter helper; `Isolate.run` — чистый Dart.

**4.** UI-объекты, `BuildContext`, большинство live callbacks с захватом UI, многие native resources.

**5.** Примитивы, простые List/Map, SendPort, объекты по copyable правилам (на практике — «простые данные»).

**6.** Spawn isolate, обмен портами, цикл обработки сообщений, явный kill/shutdown.

**7.** Пробрасываются в Future от `Isolate.run` / требуют обработки на портах worker-а.

**8.** Не все плагины thread-safe; UI и platform channels обычно на main isolate.
