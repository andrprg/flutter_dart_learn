# Шпаргалка: Mini Apps (сквозная практика)

`10_mini_apps` собирает навыки курса в маленькие, но реалистичные сценарии: модели + repository + `TaskEither` + (дальше) state/UI. Логика стартует в `mini_apps_task.dart`; подпапки `1_*`…`6_*` — место для полноценных приложений по мере роста проекта.

## 1. Место в учебном пути

```
1–5  основы Dart / async / fpdart / UI / app skills
  6  ChangeNotifier → architecture → Riverpod → fpdart+Riverpod
  7  interview drills
  8  промпты в Cursor
 10  mini-apps = «собрать вместе»
```

С чего начать mini-app (и с собеса): **домен + repository + тесты → state → UI**, не наоборот «сразу красивый экран».

## 2. Подпапки (план трека)

| Папка | Сценарий | Темы |
|---|---|---|
| `1_cli_todo` | Todo | формы, списки, фильтры, mock persistence, Riverpod |
| `2_weather_ui` | Погода | TaskEither, fake API, loading/error/data, retry |
| `3_auth_flow_app` | Auth | валидация, session, go_router redirect |
| `4_shopping_cart` | Корзина | Map id→item, derived total, checkout |
| `5_advanced_todo_app` | Todo+ | слои, кэш, расширенный UX |
| `6_agentic_chat` | Chat / agents | задел под AI-сценарии |

Сейчас задания по ядру сценариев 1–4 живут в общем `mini_apps_task.dart`. Подпапки можно наполнять отдельными Flutter-приложениями; **одна** эта шпаргалка покрывает весь модуль.

## 3. Общий каркас

```dart
typedef MiniAppTask<T> = TaskEither<MiniAppFailure, T>;

sealed class MiniAppFailure { const MiniAppFailure(); }
class ValidationMiniAppFailure extends MiniAppFailure { /* ... */ }
class NetworkMiniAppFailure extends MiniAppFailure { /* ... */ }
```

- **Fake API** за интерфейсом репозитория (`TodoRepository`, `WeatherRepository`, `AuthRepository`).
- UI (когда появится) смотрит `AsyncValue` / явные ветки empty · loading · error · data + **retry**.
- fpdart: Either/TaskEither **до** UI; на границе — fold / `taskToAsyncValue` (см. `6_state_management/fpdart_riverpod`).

## 4. Mini App 1 — Todo

```dart
MiniAppTask<TodoItem> createTodo(TodoRepository repo, String title);
List<TodoItem> filterTodos(List<TodoItem> todos, TodoFilter filter);
MiniAppTask<TodoItem> toggleTodo(TodoRepository repo, String id);
```

Пустой title → `Left(ValidationMiniAppFailure)`. Фильтры: `all` / `active` / `completed`.

## 5. Mini App 2 — Weather

```dart
Either<MiniAppFailure, String> validateCity(String city);
MiniAppTask<Weather> loadWeather(WeatherRepository repo, String city);
String weatherSummary(Weather weather); // текст для карточки
```

Цепочка: validate → `fetchWeather`. UI: loading / data / error + кнопка повтора.

## 6. Mini App 3 — Auth

```dart
Either<MiniAppFailure, LoginCredentials> validateLogin(email, password);
MiniAppTask<UserSession> login(AuthRepository repo, email, password);
String? authRedirect({required bool isLoggedIn, required String location});
```

Минимальный критерий auth flow: redirect на login, сессия, возврат на intended route (go_router). Сообщения об ошибках — безопасные (без утечки лишнего).

## 7. Mini App 4 — Shopping cart

```dart
Cart addToCart(Cart cart, Product product);
Cart changeQuantity(Cart cart, String productId, int quantity); // <=0 → удалить
int cartTotal(Cart cart);
Either<MiniAppFailure, OrderDraft> checkout(Cart cart);
```

State: нормализованный `Map<String, CartItem>`, total — **derived**, один source of truth. Checkout валидирует «корзина не пуста» и т.п.

## 8. Definition of Done

Из interview-ответов модуля:

- [ ] Happy path + edge (пустой ввод, сеть, пустая корзина)
- [ ] Тесты логики (repository / pure functions)
- [ ] UI-ветки loading / empty / error / data (когда есть UI)
- [ ] Retry там, где сеть
- [ ] Ручной прогон сценария

Когда выносить в package/layer: появляется **повтор** и тесты тормозятся из‑за связности с UI.

## 9. Как собирать сценарий по слоям

Общий порядок для всех четырёх приложений:

1. Модель и инварианты (`TodoItem`, `Cart`, пустой title).
2. Порт репозитория и фейк с предсказуемой ошибкой сети.
3. Функции сценария, которые возвращают `MiniAppTask` / `Either`.
4. Тест happy path и одного `Left` без виджетов.
5. Состояние экрана: idle / loading / data / empty / error.
6. Виджеты, которые это состояние только рисуют.

Пока нет пункта 4, рано полировать вёрстку: нечем поймать регрессию.

Todo: фильтр не ходит в репозиторий, это чистая функция над уже загруженным списком. Иначе смена фильтра мигает loading. Toggle оптимистично меняет галочку только если умеешь откатить `Left`. В учебном варианте проще дождаться `Right` и заменить элемент.

Погода: город проверяют до запроса. Ошибка валидации — не `NetworkMiniAppFailure`. Повтор жмёт тот же `loadWeather`, не восстанавливает прошлый успешный город молча, если поле уже другое.

Auth: `authRedirect` чистая функция от флага сессии и location. Её тестируют таблицей пар без `GoRouter`. Сессию после успешного `login` хранит один источник. Экран логина не держит свой `bool loggedIn`, разъехавшийся с репозиторием.

Корзина: ключ карты — id товара. Повторное добавление увеличивает quantity, а не кладёт вторую строку. `changeQuantity` с нулём или отрицательным удаляет ключ. `cartTotal` считается из строк, отдельное поле `total` рассинхронизируется. `checkout` на пустой карте — `Left`, заказ не создаётся.

## 10. Ошибки, которые путают экраны

`ValidationMiniAppFailure` показывают у поля. `NetworkMiniAppFailure` — баннер и кнопка повтора. Один виджет `Text(error)` на оба типа учит пользователя жать «повторить» на пустом имени.

Пустой список дел после успешной загрузки — empty state «пока ничего нет», не ошибка. Пустой ответ погоды без исключения — тоже данные, если контракт так устроен; в этом модуле фейк либо возвращает `Weather`, либо `Left`.

Loading на весь экран во время toggle прячет список. Локальный флаг на строке честнее. Общий loading уместен на первой загрузке и на pull-to-refresh, если список ещё нечего показать.

## 11. Вопросы с собеса (кратко)

1. С чего начать? — domain + repo + тесты.
2. Fake API vs UI? — интерфейс + delayed fake; UI на AsyncValue.
3. Auth критерий? — redirect, session, return URL.
4. Корзина state? — Map + derived totals.
5. empty/loading/error? — явные ветки + retry.
6. Когда layers/package? — повтор и боль тестов.
7. fpdart граница? — Either в домене; UI — fold/AsyncValue.
8. DoD? — тесты логики + ручной UI.

Практика: `mini_apps_task.dart` + `mini_apps_task_test.dart`.
