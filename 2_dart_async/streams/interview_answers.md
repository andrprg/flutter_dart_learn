# Ответы: Streams

**1.** Single — один слушатель, события с буферизацией до listen. Broadcast — много слушателей, без «прошлых» событий.

**2.** Создать свой поток: `add`, `addError`, `close`. Есть sync/async версии.

**3.** Хранить `StreamSubscription` и `cancel` в dispose. `await for` выходит при break/cancel.

**4.** Генерация Stream. `yield` — элемент, `yield*` — проксирует другой stream/iterable.

**5.** Производитель быстрее потребителя. Стратегии: pause subscription, буфер, drop, isolate.

**6.** Ленивые преобразования потока. Debounce часто через `rxdart` или ручной Timer.

**7.** Future — 1 результат. Stream — 0..N событий во времени.

**8.** `expectLater(stream, emitsInOrder([...]))` из `matcher` / flutter_test.
