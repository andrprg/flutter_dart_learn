import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'change_notifier_task.dart';

void main() {
  group('ChangeNotifier helpers', () {
    test('CounterNotifier и reset', () {
      final c = CounterNotifier();
      c.increment();
      c.increment();
      expect(c.value, 2);
      c.decrement();
      expect(c.value, 1);
      c.decrement();
      c.decrement();
      expect(c.value, 0);
      resetCounter(c);
      expect(c.value, 0);
    });

    test('notifyOnce / ValueNotifier / countNotifications', () {
      final c = CounterNotifier();
      var hits = 0;
      notifyOnce(c, () => hits++);
      expect(hits, 1);

      final title = createTitleNotifier('Hi');
      expect(title.value, 'Hi');

      final n = ValueNotifier(0);
      final counted = countNotifications(n, () => n.value++);
      expect(counted, greaterThan(0));
      n.dispose();
      title.dispose();
    });

    test('CartNotifier', () {
      final cart = CartNotifier();
      cart.add(const CartLine(id: 'a', price: 10, qty: 2));
      expect(cart.total, 20);
      cart.updateQty('a', 3);
      expect(cart.total, 30);
      cart.remove('a');
      expect(cart.lines, isEmpty);
      expect(const CartLine(id: 'a', price: 1, qty: 1).copyWith(qty: 5).qty, 5);
    });

    test('merge / bestFor / listenTemporarily / safeNotify', () {
      expect(valueNotifierBestFor(), 'single_value');
      expect(changeNotifierBestFor(), 'complex_state');

      final a = CounterNotifier();
      final b = CounterNotifier();
      final merged = mergeListenables(a, b);
      var hits = 0;
      merged.addListener(() => hits++);
      a.increment();
      expect(hits, greaterThan(0));

      final c = CounterNotifier();
      var temp = 0;
      listenTemporarily(c, () => temp++, () => c.increment());
      expect(temp, 1);
      c.increment();
      expect(temp, 1);

      c.dispose();
      expect(safeNotify(c), isFalse);
    });
  });
}
