# Ответы: Theming Material 3

**1.** ColorScheme — палитра ролей; ThemeData собирает component themes + typography.

**2.** Свои токены (spacing, brand) с lerp/copyWith, доступ через `Theme.of(context).extension<T>()`.

**3.** `ThemeMode` + `MaterialApp.theme/darkTheme`. Слушать platform brightness.

**4.** `Theme(data: Theme.of(context).copyWith(...), child: ...)`.

**5.** display/headline/title/body/label — семантические стили M3.

**6.** Генерирует гармоничную палитру M3 из одного seed.

**7.** Брать из ColorScheme (`primary`, `surface`…) для dark mode и консистентности.

**8.** Можно подтягивать wallpaper colors (пакеты/platform) — плюс на senior-собесе.
