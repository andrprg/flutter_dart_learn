# Ответы: Event Loop

**1.** Один UI/main isolate: sync код → microtask queue → event queue. Microtasks всегда раньше следующих events.

**2.** `scheduleMicrotask`, завершение `Future` (then), `Future.microtask`.

**3.** `Future.delayed`, timer, I/O, user events, `Future(() => ...)`.

**4.** Event loop не обрабатывает кадры/events, пока sync код не закончится.

**5.** Сначала sync, потом все microtasks, потом events (Future).

**6.** Да. Тело до первого await выполняется sync в текущем turn; продолжение — позже.

**7.** Каждый frame — события на event queue. Тяжёлая работа → jank → isolates/compute.

**8.** Да, бесконечная постановка microtasks не даст обработать events.
