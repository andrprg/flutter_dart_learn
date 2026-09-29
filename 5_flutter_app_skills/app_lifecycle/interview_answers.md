# Ответы: App Lifecycle

**1.** resumed/inactive/paused/detached/hidden — смысл для sync/pause.

**2.** Подписка на `didChangeAppLifecycleState` в State; add/remove observer.

**3.** Сохранить черновик, пауза плеера/websocket sync, освободить камеру.

**4.** inactive — кратковременно (звонок/CC). paused — фон.

**5.** Черновик в storage; RestorationMixin — OS-level UI restoration.

**6.** Процесс могут убить; persist критичное раньше (на pause).

**7.** UI не виден, но ещё не обязательно paused — учитывайте в логике.

**8.** Симулировать события binding / свои контроллеры состояний.
