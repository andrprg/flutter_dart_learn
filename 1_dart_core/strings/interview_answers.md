# Ответы: Strings и RegExp

**1.** Нет, immutable. Конкатенация создаёт новые объекты; для сборки — `StringBuffer`.

**2.** Простой идентификатор — `$name`. Выражение — `${obj.field}`.

**3.** `substring(start, end)`, `replaceRange`. Осторожно с рунами/эмодзи: лучше `characters` package.

**4.** `RegExp(pattern)`, `hasMatch`, `firstMatch`, `allMatches`, groups через `Match`.

**5.** `RegExp(..., multiLine: true, caseSensitive: false, dotAll: true)`.

**6.** `RegExp.escape(userInput)`.

**7.** `length` считает UTF-16 code units, не графемы. Суррогатные пары ломают наивный index.

**8.** Нормализация ввода, форматирование, CSV/query parsing.
