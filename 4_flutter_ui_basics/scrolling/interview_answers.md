# Ответы: Scrolling

**1.** builder ленивый — создаёт детей по мере скролла. Обычный ListView строит всех детей сразу.

**2.** Слушать offset, jump/animateTo. Обязательно dispose, иначе утечки.

**3.** Scrollable должен уметь overscroll; часто нужен AlwaysScrollableScrollPhysics для коротких списков.

**4.** Слушать metrics: `pixels >= maxScrollExtent - threshold` или NotificationListener.

**5.** PageView — страницы жестом. TabBarView связан с TabController.

**6.** Общий контроллер для scaffold/scroll; конфликт двух primary scrollables.

**7.** Связка header sliver + внутренний tab scroll.

**8.** Start/Update/End/Overscroll — для custom эффектов и load-more.
