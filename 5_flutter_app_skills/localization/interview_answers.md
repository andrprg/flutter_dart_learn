# Ответы: Localization (i18n)

**1.** Официальный путь Flutter — ARB/codegen. Ручной — для обучения концепций.

**2.** Выбрать лучший из device locales среди supported, иначе fallback (часто en).

**3.** CLDR: en one/other; ru one/few/many — не хардкодить `count==1` для всех языков.

**4.** Именованные `{name}` / ICU messages; не конкатенировать предложения.

**5.** `Directionality`, EdgeInsets directional, не зеркалить всё бездумно.

**6.** `intl` DateFormat/NumberFormat по locale.

**7.** Все user-facing в l10n; логи/ключи ошибок — отдельно.

**8.** Прогон lookup/plural для нескольких locales.
