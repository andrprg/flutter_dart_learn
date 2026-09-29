# Ответы: Patterns, Records, Sealed

**1.** Неизменяемый агрегатный тип `(int, String)` / named record fields без отдельного class.

**2.** Деструктуризация и exhaustiveness на sealed/enum. Меньше boilerplate `is` + cast.

**3.** `if (x case int n when n > 0)` — паттерн + объявление + when в одном.

**4.** `case User(:final name, :final age)` достаёт поля.

**5.** Компилятор требует покрыть все подтипы — безопасный рефакторинг.

**6.** `case [first, ...rest]`, `case {"id": int id}`.

**7.** Локальные пары/тройки без поведения. Для домена с методами/инвариантами — class.

**8.** На sealed лучше без default — иначе потеряете предупреждение о новом case.
