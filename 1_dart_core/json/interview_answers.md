# Ответы: JSON и модели

**1.** `jsonDecode` → `Map`/`List` → ручной `fromJson`. Ошибки типов → `FormatException`.

**2.** JSON значения неоднородны: num/String/bool/List/Map/null.

**3.** Codegen меньше boilerplate и ошибок; ручной — контроль и понимание на mid-собесе.

**4.** `T?`, отсутствие ключа и explicit null. Документировать контракт API.

**5.** Рекурсивно `Child.fromJson`, `list.map(E.fromJson).toList()` с проверкой типа.

**6.** Обычно ISO-8601 string → `DateTime.parse`. Учитывать UTC/local.

**7.** `switch` + fallback / throw / `unknown` case — по политике API compatibility.

**8.** JSON/API форма меняется чаще домена; маппинг в data-слое изолирует UI/domain.
