# Ответы: SnackBar, Dialog, BottomSheet

**1.** Messenger переживает смену Scaffold (навигация); современный способ SnackBar.

**2.** Да, результат `Navigator.pop(context, value)`. null если dismiss barrier.

**3.** Тап вне диалога закрывает. Для destructive — часто false.

**4.** Modal блокирует остальной UI (`showModalBottomSheet`). Persistent — часть scaffold.

**5.** `Navigator.pop(context, result)` / `await showModalBottomSheet<T>`.

**6.** После await проверить `context.mounted` перед новым UI.

**7.** Undo/Retry через `SnackBarAction`; не держать долго критичный state только там.

**8.** Показывает над всем стеком маршрутов; важно при nested navigators.
