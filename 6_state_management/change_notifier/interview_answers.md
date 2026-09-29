# Ответы: ChangeNotifier

**1.** Хранит listeners; `notifyListeners()` синхронно вызывает их.

**2.** ValueNotifier — одно value + notify при set. ChangeNotifier — произвольная модель.

**3.** Да для своих notifier/animation; снять listeners.

**4.** Слушать несколько listenables как один.

**5.** Provider исторически часто оборачивал ChangeNotifier. Riverpod — другой runtime, но идея подписки та же.

**6.** Не уведомлять после dispose — assert/fail.

**7.** Один примитив/флаг UI без сложной логики.

**8.** addListener + expect value; без UI.
