# Ответы: Deep Links

**1.** Custom scheme `myapp://`. Universal/App Links — https домен с verification.

**2.** Безопаснее (domain ownership), лучше UX из браузера/почты.

**3.** URL → route match → path/query params; остальное в redirect.

**4.** Сохранить intended location, на login redirect query, после auth вернуться.

**5.** Trailing slash, www, http→https — канонизировать чтобы не плодить маршруты.

**6.** error/fallback home; не крашить приложение.

**7.** intent-filters / apple-app-site-association — на собесе упомянуть.

**8.** Unit parse/match + integration открытие URI.
