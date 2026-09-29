# Ответы: Типичные ошибки Junior Flutter

**1.** Рекурсивные rebuilds / assert. Планировать обновление post-frame или менять state вне build.

**2.** Виджет мог dispose → crash. Проверять `mounted`/`context.mounted`.

**3.** Пересоздание Future → повторные запросы. Кэшировать Future.

**4.** Утечки и warnings. Controllers/FocusNode/AnimationController — dispose.

**5.** Нужен Expanded/SizedBox/shrinkWrap с пониманием цены.

**6.** Зависит: лучше `didChangeDependencies` для MediaQuery/Provider of.

**7.** UI не обновится.

**8.** Ребилд всего экрана; дробить виджеты, const, селекторы state.
