/// ЗАДАЧА 29 — Value object: ==, hashCode, copyWith
/// Уровень: Mid
/// Тема: Иммутабельность, контракт равенства
///
/// Допишите [Money]:
/// - два объекта равны, если совпадают [amount] и [currency]
/// - [hashCode] согласован с == (одинаковые объекты → одинаковый hash)
/// - [copyWith] возвращает новый экземпляр и не мутирует исходный
///   (если аргумент не передан — поле остаётся прежним)
///
/// На собеседовании спрашивают, почему без своего == виджеты и Set
/// считают два «одинаковых» объекта разными.

// ─── Ваше решение ────────────────────────────────────────────────────────────

class Money {
  final int amount;
  final String currency;

  const Money({required this.amount, required this.currency});

  Money copyWith({int? amount, String? currency}) {
    // TODO: верните новый Money
    throw UnimplementedError();
  }

  @override
  bool operator ==(Object other) {
    // TODO: сравните amount и currency
    throw UnimplementedError();
  }

  @override
  int get hashCode {
    // TODO: согласуйте с ==
    throw UnimplementedError();
  }
}

// ─── Эталонное решение ───────────────────────────────────────────────────────

class MoneyAnswer {
  final int amount;
  final String currency;

  const MoneyAnswer({required this.amount, required this.currency});

  MoneyAnswer copyWith({int? amount, String? currency}) {
    return MoneyAnswer(
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MoneyAnswer &&
        other.amount == amount &&
        other.currency == currency;
  }

  @override
  int get hashCode => Object.hash(amount, currency);

  @override
  String toString() => 'Money($amount $currency)';
}

// ─── Мини-демо ────────────────────────────────────────────────────────────────

void main() {
  const a = MoneyAnswer(amount: 100, currency: 'RUB');
  final b = a.copyWith(amount: 250);
  print(a == const MoneyAnswer(amount: 100, currency: 'RUB'));
  print(b);
  print(a.amount);
}
