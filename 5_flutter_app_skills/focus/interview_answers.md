# Ответы: Focus

**1.** Node — фокус конкретного контрола. Scope — область обхода/primary focus subtree.

**2.** Программный фокус; unfocus снимает primary focus (часто при тапе вне поля).

**3.** Кнопка клавиатуры «далее» → focus следующего поля.

**4.** Да, если создаёте сами в State.

**5.** false для disabled полей — не участвует в traversal.

**6.** Порядок обхода Tab: ReadingOrder/Ordered/WidgetOrder; NumericFocusOrder.

**7.** Запрос фокуса при первом frame; не злоупотреблять на сложных экранах.

**8.** Видимый focus indicator важен для клавиатурных пользователей.
