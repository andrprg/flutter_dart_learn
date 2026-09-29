# Ответы: Responsive / Adaptive

**1.** Responsive — тянется layout. Adaptive — меняет UX-паттерн (NavigationRail vs BottomBar).

**2.** Material window size classes / свои 600/840; лучше LayoutBuilder чем «магический MediaQuery везде».

**3.** Две панели: список + детали; на compact — stack navigation.

**4.** `OrientationBuilder` / MediaQuery.orientation; не дублировать бизнес-логику.

**5.** Учитывать `MediaQuery.textScaler`; не фиксировать высоты текста жёстко.

**6.** Вырезы и клавиатура; padding от MediaQuery.viewInsets.

**7.** Масштаб ребёнка в доступный бокс; осторожно с читаемостью.

**8.** Widget тесты с разными surface size / golden tests.
