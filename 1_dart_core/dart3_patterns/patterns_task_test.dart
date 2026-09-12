import 'package:test/test.dart';

import 'patterns_task.dart';

void main() {
  group('пример', () {
    test('запись распаковывается в title и год', () {
      expect(exampleTitleFromRecord(), 'My Document (2023)');
    });
  });

  group('makeMetadata', () {
    test('собирает позиционное и именованное поля', () {
      final modified = DateTime.utc(2023, 5, 10);
      expect(
        makeMetadata('My Document', modified),
        ('My Document', modified: modified),
      );
    });
  });

  group('positionalGetters', () {
    test('\$1 и \$2 пропускают именованные поля', () {
      expect(
        positionalGetters((named: 'v', 'y', named2: 'x', 'z')),
        'y-z',
      );
    });
  });

  group('unpackMetadata', () {
    test('деструктурирует title и modified', () {
      final modified = DateTime.utc(2023, 5, 10);
      expect(
        unpackMetadata(('My Document', modified: modified)),
        'My Document | ${modified.toIso8601String()}',
      );
    });
  });

  group('titleIgnoringDate', () {
    test('отбрасывает второе поле', () {
      expect(
        titleIgnoringDate(
          ('Notes', modified: DateTime.utc(2020, 1, 1)),
        ),
        'Notes',
      );
    });
  });

  group('unpackRenamed', () {
    test('переименовывает modified в localModified', () {
      final modified = DateTime.utc(2023, 5, 10);
      expect(
        unpackRenamed(('Doc', modified: modified)),
        ('Doc', modified),
      );
    });
  });

  group('parseMetadata', () {
    test('читает title и modified из вложенной Map', () {
      final parsed = parseMetadata(sampleDocument());
      expect(parsed.$1, 'My Document');
      expect(parsed.modified, DateTime.parse('2023-05-10'));
    });

    test('бросает FormatException на неожиданный JSON', () {
      expect(() => parseMetadata({}), throwsFormatException);
      expect(() => parseMetadata({'metadata': 'nope'}), throwsFormatException);
      expect(
        () => parseMetadata({
          'metadata': {'title': 1, 'modified': '2023-05-10'},
        }),
        throwsFormatException,
      );
    });
  });

  group('parseBlockFields', () {
    test('достаёт type и text, игнорируя checked', () {
      expect(
        parseBlockFields({
          'type': 'checkbox',
          'checked': false,
          'text': 'Learn Dart 3',
        }),
        (type: 'checkbox', text: 'Learn Dart 3'),
      );
    });

    test('бросает FormatException без нужных ключей', () {
      expect(() => parseBlockFields({'type': 'p'}), throwsFormatException);
      expect(() => parseBlockFields('block'), throwsFormatException);
    });
  });

  group('parseBlocks', () {
    test('разбирает список блоков документа', () {
      final blocks = parseBlocks(sampleDocument());
      expect(blocks.length, 3);
      expect(blocks.first, (type: 'h1', text: 'Chapter 1'));
      expect(blocks.last.type, 'checkbox');
      expect(blocks.last.text, 'Learn Dart 3');
    });

    test('бросает FormatException без blocks', () {
      expect(() => parseBlocks({'metadata': {}}), throwsFormatException);
    });
  });

  group('styleForType', () {
    test('h1 — heading, p и checkbox — body, иначе fallback', () {
      expect(styleForType('h1'), 'heading');
      expect(styleForType('p'), 'body');
      expect(styleForType('checkbox'), 'body');
      expect(styleForType('quote'), 'fallback');
    });
  });

  group('formatRelativeDate', () {
    final now = DateTime.utc(2023, 5, 24);

    test('сегодня, завтра, вчера', () {
      expect(formatRelativeDate(now, now: now), 'сегодня');
      expect(
        formatRelativeDate(now.add(const Duration(days: 1)), now: now),
        'завтра',
      );
      expect(
        formatRelativeDate(now.subtract(const Duration(days: 1)), now: now),
        'вчера',
      );
    });

    test('дни назад и дни вперёд без недель', () {
      expect(
        formatRelativeDate(DateTime.utc(2023, 5, 10), now: now),
        '14 дн. назад',
      );
      expect(
        formatRelativeDate(DateTime.utc(2023, 5, 29), now: now),
        'через 5 дн.',
      );
    });
  });

  group('formatRelativeDateWithWeeks', () {
    final now = DateTime.utc(2023, 5, 24);

    test('две недели назад, как в коделабе', () {
      expect(
        formatRelativeDateWithWeeks(DateTime.utc(2023, 5, 10), now: now),
        '2 нед. назад',
      );
    });

    test('недели вперёд и дни, если |days| <= 7', () {
      expect(
        formatRelativeDateWithWeeks(DateTime.utc(2023, 6, 7), now: now),
        'через 2 нед.',
      );
      expect(
        formatRelativeDateWithWeeks(DateTime.utc(2023, 5, 21), now: now),
        '3 дн. назад',
      );
    });
  });

  group('blockFromJson', () {
    test('собирает HeaderBlock, ParagraphBlock и CheckboxBlock', () {
      final header = blockFromJson({'type': 'h1', 'text': 'Chapter 1'});
      expect(header, isA<HeaderBlock>());
      expect((header as HeaderBlock).text, 'Chapter 1');

      final paragraph = blockFromJson({'type': 'p', 'text': 'Hello'});
      expect(paragraph, isA<ParagraphBlock>());

      final checkbox = blockFromJson({
        'type': 'checkbox',
        'text': 'Learn Dart 3',
        'checked': true,
      });
      expect(checkbox, isA<CheckboxBlock>());
      expect((checkbox as CheckboxBlock).isChecked, isTrue);
    });

    test('бросает FormatException на неизвестный type', () {
      expect(
        () => blockFromJson({'type': 'quote', 'text': 'Hi'}),
        throwsFormatException,
      );
    });
  });

  group('renderBlock', () {
    test('рендерит заголовок, абзац и чекбокс', () {
      expect(renderBlock(const HeaderBlock('Chapter 1')), '# Chapter 1');
      expect(renderBlock(const ParagraphBlock('Hello')), 'Hello');
      expect(
        renderBlock(const CheckboxBlock('Learn Dart 3', false)),
        '[ ] Learn Dart 3',
      );
      expect(
        renderBlock(const CheckboxBlock('Learn Dart 3', true)),
        '[x] Learn Dart 3',
      );
    });
  });

  group('hasUncheckedItem', () {
    test('находит неотмеченный чекбокс', () {
      expect(
        hasUncheckedItem(const [
          HeaderBlock('H'),
          CheckboxBlock('Learn Dart 3', false),
        ]),
        isTrue,
      );
      expect(
        hasUncheckedItem(const [
          ParagraphBlock('p'),
          CheckboxBlock('Done', true),
        ]),
        isFalse,
      );
    });
  });

  group('documentSummary', () {
    test('собирает title, относительную дату и число блоков', () {
      final modified = DateTime.parse('2023-05-10');
      expect(
        documentSummary(
          sampleDocument(),
          now: modified.add(const Duration(days: 14)),
        ),
        'My Document\n'
        'Last modified: 2 нед. назад\n'
        'Блоков: 3',
      );
    });
  });
}
