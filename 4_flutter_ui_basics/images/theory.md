# Шпаргалка: Images и assets

Перед задачами прочитай этот файл, затем решай `images_task.dart`.

Картинка в Flutter — виджет `Image` + `ImageProvider` (`AssetImage`, `NetworkImage`, `MemoryImage`). Важно: **BoxFit**, placeholder/error, aspect ratio и память.

## 1. Источники

| API | Откуда | Когда |
|---|---|---|
| `Image.asset` | `pubspec.yaml` assets | Локальные иконки, иллюстрации |
| `Image.network` | URL | Аватары, CDN |
| `Image.memory` | `Uint8List` | Камера, кэш в RAM |

```dart
Image.asset('assets/logo.png', width: 120, fit: BoxFit.contain);
Image.network(url, fit: BoxFit.cover);
```

По пути: `http(s)://` → network, `assets/` → asset (как в `kindFromPath`).

В `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/images/
```

## 2. BoxFit

Как вписать изображение в выделенный прямоугольник:

| BoxFit | Поведение |
|---|---|
| **cover** | заполнить, **обрезать** лишнее, без искажений → аватары |
| **contain** | целиком внутри, возможны поля → логотипы |
| **fill** | растянуть на весь бокс, **с искажением** |
| fitWidth / fitHeight | подогнать одну ось |
| none / scaleDown | без увеличения / только уменьшение |

```dart
BoxFit avatarBoxFit() => BoxFit.cover;
BoxFit logoBoxFit() => BoxFit.contain;
BoxFit stretchBoxFit() => BoxFit.fill;
```

## 3. AspectRatio

Чтобы сетка/карточка не прыгала по высоте, зафиксируй пропорцию:

```dart
aspectRatio = width / height;
height = width / ratio;
```

```dart
AspectRatio(
  aspectRatio: 16 / 9,
  child: Image.network(url, fit: BoxFit.cover),
);
```

## 4. loadingBuilder / errorBuilder

Сеть нестабильна — всегда предусматривай состояния:

```dart
Image.network(
  url,
  fit: BoxFit.cover,
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return const ImagePlaceholder(); // серый бокс + CircularProgressIndicator
  },
  errorBuilder: (context, error, stack) => const ImageErrorBox(),
);
```

`needsPlaceholder`: для **network** — да; asset/memory обычно уже локальные.

`FadeInImage` — плавный переход placeholder → картинка (`FadeInImage.assetNetwork` и т.п.).

## 5. Кэш и пакеты

`Image.network` кэширует в памяти через `ImageCache`, но без диска и политики eviction «из коробки» для сложных кейсов. Часто берут `cached_network_image` (диск + placeholder). В задачах модуля достаточно стандартного API.

## 6. Resolution-aware assets

Файлы `image.png`, `2.0x/image.png`, `3.0x/image.png` — Flutter выберет вариант под `devicePixelRatio`. В pubspec указываешь логический путь `assets/image.png`.

## 7. Память и OOM

Большие фото (камера, галерея) в полном разрешении раздувают RAM. Сжимай/`ResizeImage`/`cacheWidth`/`cacheHeight`, не держи десятки 4K в списке одновременно, dispose контроллеров/провайдеров где нужно.

## 8. Декодирование и `cacheWidth`

Файл 4000×3000 в виджете 100×100 без подсказки декодируется в полный битмап: ширина × высота × 4 байта. `cacheWidth` / `cacheHeight` говорят декодеру целевой размер в **физических** пикселях.

```dart
Image.network(
  url,
  width: 100,
  height: 100,
  fit: BoxFit.cover,
  cacheWidth: (100 * MediaQuery.devicePixelRatioOf(context)).round(),
);
```

Достаточно одной стороны, вторую сохранит пропорция декодера. Слишком маленький `cacheWidth` мылит картинку на экране. Слишком большой не экономит память.

`Image.network` кладёт результат в `ImageCache` (лимит по числу изображений и по байтам). Кадр, который вытеснен, при возврате в список декодируется снова — отсюда мигание. `precacheImage(NetworkImage(url), context)` греет кэш до показа. `gaplessPlayback: true` на смене `ImageProvider` оставляет старый кадр, пока новый не готов, чтобы не мигать плейсхолдером.

Ошибка сети и ошибка декодирования обе идут в `errorBuilder`. Различить их в UI обычно не нужно: человек видит «нет картинки». В лог имеет смысл писать `error`.

## 9. Asset, масштаб и `DecorationImage`

Каталог `2.0x/` выбирается по `devicePixelRatio`, не по логической ширине виджета. На экране 3x Flutter возьмёт `3.0x`, если файл есть, иначе ближайший и отмасштабирует.

`Image.asset('assets/a.png')` и путь в `pubspec` должны совпасть с тем, что объявлено. Указан каталог `assets/images/` — файлы внутри доступны по полному пути. Забыл строку в pubspec — в рантайме `Unable to load asset`, это не сеть.

`BoxDecoration(image: DecorationImage(image: provider, fit:))` рисует фон. Жесты и семантика у декорации слабее, чем у `Image`: для аватара с кнопкой чаще `ClipOval` + `Image`. `DecorationImage` не имеет `errorBuilder` так же прямо — обрабатывай провайдер отдельно или оставайся на `Image`.

`frameBuilder` у `Image` даёт момент «первый кадр готов» — им делают fade. `FadeInImage` — готовая связка placeholder + fade.

## 10. Типичные ошибки

- `BoxFit.fill` на аватаре: лицо растянуто. Для кропа — `cover` плюс квадратный бокс или `AspectRatio`.
- Высота карточки от «как загрузится картинка» — список прыгает. Сначала `AspectRatio` или фиксированный слот, потом изображение.
- Вечный `CircularProgressIndicator` без `errorBuilder`: офлайн выглядит как бесконечная загрузка только если ошибку не отрисовали. Если `loadingBuilder` при ошибке не сменяется — проверь, что `errorBuilder` задан.
- Десять полноразмерных фото в `Column` без `cacheWidth` — OOM на дешёвом Android.
- Путать логические пиксели виджета и пиксели файла.

## 11. Сборка модуля

`ImageSpec` + kind; виджеты `ImagePlaceholder`, `ImageErrorBox`, `FittedNetworkImage` (AspectRatio + network + builders).

---

Дальше: `images_task.dart`.
