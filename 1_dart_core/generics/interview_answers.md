# Ответы: Generics и Extensions

**1.** Типобезопасные коллекции и API без потери типа (`List<int>` вместо `List<dynamic>`).

**2.** Ограничение type parameter: `T` — подтип `num`, можно вызывать API числа.

**3.** Добавление методов/геттеров к существующему типу без изменения класса. Синтаксический сахар, не ломает инкапсуляцию private.

**4.** Только если extension в той же library, что и тип.

**5.** `List<T?>` — список есть, элементы могут быть null. `List<T>?` — сам список может быть null.

**6.** `List<Dog>` не всегда безопасен как `List<Animal>` при записи. Чтение ковариантно, запись опасна — runtime check.

**7.** `abstract interface class Repo<T> { T? getById(String id); }` + реализация с `Map<String, T>`.

**8.** Короткие алиасы: `typedef JsonMap = Map<String, dynamic>;` / `typedef Mapper<T,R> = R Function(T);`.
