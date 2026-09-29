# Ответы: OOP в Dart

**1.** Может вернуть существующий экземпляр, подтип или бросить ошибку; не обязан создавать новый объект через `this`.

**2.** `extends` — наследование реализации (один родитель). `implements` — контракт API, реализуете все члены. С Dart 3 есть `interface class` / `abstract interface class`.

**3.** Переиспользуемое поведение без полного наследования. Подмешивается через `with`. Нельзя создать экземпляр mixin.

**4.** Переопределять вместе. Equal objects → equal hashCode. Для value-объектов сравнивают поля. Иначе ломаются `Set`/`Map`.

**5.** Создаёт canonicalized compile-time константу. Все поля `final`, аргументы const. Экономит память и даёт identical.

**6.** Обычный generative инициализирует экземпляр. Named — альтернативные точки входа (`User.fromJson`). `factory` — особый случай.

**7.** Ограничивает иерархию одним library; включает exhaustiveness checking в switch.

**8.** Нет multiple inheritance классов. Композиция: `implements` + `with` mixins.
