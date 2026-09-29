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

## 8. Сборка модуля

`ImageSpec` + kind; виджеты `ImagePlaceholder`, `ImageErrorBox`, `FittedNetworkImage` (AspectRatio + network + builders).

---

Дальше: `images_task.dart`.
