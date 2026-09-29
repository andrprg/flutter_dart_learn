# Ответы: Networking

**1.** http — простой. dio — interceptors, cancel, FormData. На собесе важны таймауты/ошибки/ретраи.

**2.** Retry безопасно на GET/idempotent; осторожно с POST. Коды 408/429/5xx — кандидаты.

**3.** Конфиг/env + secure storage для token; interceptor добавляет Authorization.

**4.** connect/receive timeout; UX cancel; различать network vs server error.

**5.** Единый `ApiException(status, message)` / Either Left; парсить body `message`.

**6.** Защита от MITM; сложность ротации сертификатов — middle/senior тема.

**7.** page/cursor; sync со scroll load-more; не дублировать запросы (in-flight flag).

**8.** Мок transport/adapter; golden contract tests на JSON fixtures.
