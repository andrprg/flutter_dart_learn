# Ответы: Accessibility

**1.** Около 48x48 dp по Material; проверять Semantics/hit area.

**2.** Явные label/value/button/hint для screen readers.

**3.** Убрать шум; объединить детей в один semantic node.

**4.** Текст/иконки достаточный contrast ratio; не опираться только на цвет.

**5.** Важен для desktop/web: FocusTraversalGroup, order, skipTraversal.

**6.** SemanticsService.announce / live regions для динамических сообщений.

**7.** `tester.ensureSemantics()`, проверки label, `meetsGuideline`.

**8.** Помечать exclude semantics, чтобы не читались.
