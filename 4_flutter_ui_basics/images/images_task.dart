import 'package:flutter/material.dart';

// ============================================================
// 12 ЗАДАЧ ПО IMAGES И ASSETS
// ============================================================
// Цель: BoxFit, AspectRatio, placeholder/error, MemoryImage vs Network,
// выбор стратегии загрузки — без обязательного cached_network_image.

/// Источник картинки.
enum ImageSourceKind { asset, network, memory }

/// Описание картинки в UI.
class ImageSpec {
  const ImageSpec({
    required this.kind,
    required this.value,
    this.width,
    this.height,
  });

  final ImageSourceKind kind;

  /// asset path / url / пустая строка для memory (байты отдельно).
  final String value;
  final double? width;
  final double? height;
}

// ЗАДАЧА 1
// BoxFit для аватара (квадрат, без искажений, с обрезкой) -> cover.
BoxFit avatarBoxFit() {
  throw UnimplementedError();
}

// ЗАДАЧА 2
// BoxFit для логотипа целиком внутри контейнера без обрезки -> contain.
BoxFit logoBoxFit() {
  throw UnimplementedError();
}

// ЗАДАЧА 3
// BoxFit растянуть на весь контейнер с искажением -> fill.
BoxFit stretchBoxFit() {
  throw UnimplementedError();
}

// ЗАДАЧА 4
// Определи kind по строке:
// начинается с 'http://' или 'https://' -> network
// начинается с 'assets/' -> asset
// иначе ArgumentError.
ImageSourceKind kindFromPath(String path) {
  throw UnimplementedError();
}

// ЗАДАЧА 5
// Собери ImageSpec для network URL.
ImageSpec networkSpec(String url, {double? width, double? height}) {
  throw UnimplementedError();
}

// ЗАДАЧА 6
// Собери ImageSpec для asset path.
ImageSpec assetSpec(String path, {double? width, double? height}) {
  throw UnimplementedError();
}

// ЗАДАЧА 7
// Aspect ratio = width / height. height <= 0 -> ArgumentError.
double aspectRatioOf(double width, double height) {
  throw UnimplementedError();
}

// ЗАДАЧА 8
// Высота при известной ширине и ratio: height = width / ratio.
// ratio <= 0 -> ArgumentError.
double heightForWidth(double width, double ratio) {
  throw UnimplementedError();
}

// ЗАДАЧА 9
// Нужен ли placeholder: для network — да, для asset/memory — нет.
bool needsPlaceholder(ImageSourceKind kind) {
  throw UnimplementedError();
}

// ЗАДАЧА 10
// Виджет ImagePlaceholder — серый Container + CircularProgressIndicator по центру.
class ImagePlaceholder extends StatelessWidget {
  const ImagePlaceholder({
    this.width,
    this.height,
    super.key,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 11
// Виджет ImageErrorBox — Container с иконкой Icons.broken_image и текстом 'Ошибка'.
class ImageErrorBox extends StatelessWidget {
  const ImageErrorBox({
    this.width,
    this.height,
    super.key,
  });

  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

// ЗАДАЧА 12
// Виджет FittedNetworkImage:
// - AspectRatio(ratio)
// - Image.network(url, fit: BoxFit.cover,
//   loadingBuilder -> ImagePlaceholder,
//   errorBuilder -> ImageErrorBox)
class FittedNetworkImage extends StatelessWidget {
  const FittedNetworkImage({
    required this.url,
    required this.ratio,
    super.key,
  });

  final String url;
  final double ratio;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}
