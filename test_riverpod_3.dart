import 'package:flutter_riverpod/flutter_riverpod.dart';
class MyNotifier extends Notifier<int> {
  @override
  int build() => 0;
}
void main() {
  final c = ProviderContainer();
  final provider = NotifierProvider<MyNotifier, int>(MyNotifier.new);
  c.read(provider.notifier).state = 1;
}