import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'images_task.dart';

void main() {
  group('Images helpers', () {
    test('BoxFit helpers', () {
      expect(avatarBoxFit(), BoxFit.cover);
      expect(logoBoxFit(), BoxFit.contain);
      expect(stretchBoxFit(), BoxFit.fill);
    });

    test('kindFromPath и specs', () {
      expect(kindFromPath('https://cdn.example.com/a.png'), ImageSourceKind.network);
      expect(kindFromPath('assets/images/logo.png'), ImageSourceKind.asset);
      expect(() => kindFromPath('logo.png'), throwsArgumentError);

      final net = networkSpec('https://x/y.png', width: 40, height: 40);
      expect(net.kind, ImageSourceKind.network);
      expect(net.value, 'https://x/y.png');

      final asset = assetSpec('assets/a.png');
      expect(asset.kind, ImageSourceKind.asset);
    });

    test('aspectRatioOf / heightForWidth / needsPlaceholder', () {
      expect(aspectRatioOf(200, 100), 2);
      expect(() => aspectRatioOf(200, 0), throwsArgumentError);

      expect(heightForWidth(200, 2), 100);
      expect(() => heightForWidth(200, 0), throwsArgumentError);

      expect(needsPlaceholder(ImageSourceKind.network), isTrue);
      expect(needsPlaceholder(ImageSourceKind.asset), isFalse);
    });

    testWidgets('ImagePlaceholder и ImageErrorBox', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ImagePlaceholder(width: 80, height: 80)),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ImageErrorBox(width: 80, height: 80)),
        ),
      );
      expect(find.byIcon(Icons.broken_image), findsOneWidget);
      expect(find.text('Ошибка'), findsOneWidget);
    });

    testWidgets('FittedNetworkImage структура', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FittedNetworkImage(
              url: 'https://example.com/photo.jpg',
              ratio: 16 / 9,
            ),
          ),
        ),
      );

      expect(find.byType(AspectRatio), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);

      final ratio = tester.widget<AspectRatio>(find.byType(AspectRatio));
      expect(ratio.aspectRatio, closeTo(16 / 9, 0.001));
    });
  });
}
