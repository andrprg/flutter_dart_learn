import 'package:flutter_test/flutter_test.dart';

import 'flutter_erros.dart';

void main() {
  group('Junior Flutter errors checklist', () {
    test('файл содержит 30 учебных задач', () {
      final taskTypes = <Type>[
        Task1,
        Task2,
        Task3,
        Task4,
        Task5,
        Task6,
        Task7,
        Task8,
        Task9,
        Task10,
        Task11,
        Task12,
        Task13,
        Task14,
        Task15,
        Task16,
        Task17,
        Task18,
        Task19,
        Task20,
        Task21,
        Task22,
        Task23,
        Task24,
        Task25,
        Task26,
        Task27,
        Task28,
        Task29,
        Task30,
      ];

      expect(taskTypes.length, 30);
    });

    testWidgets(
      'после исправления Task1 не должен вызывать setState в build',
      (tester) async {
        await tester.pumpWidget(const Task1());
        await tester.pump();

        expect(tester.takeException(), isNull);
      },
      skip: true,
    );
  });
}
