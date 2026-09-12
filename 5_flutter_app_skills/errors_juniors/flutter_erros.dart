import 'package:flutter/material.dart';
import 'dart:async';

/// Файл содержит 30 типичных ошибок Junior Flutter разработчиков.
/// Твоя задача — найти и исправить каждую из них!

// ==========================================
// ЗАДАЧА 1
// ==========================================
class Task1 extends StatefulWidget {
  const Task1({Key? key}) : super(key: key);
  @override
  State<Task1> createState() => _Task1State();
}

class _Task1State extends State<Task1> {
  int count = 0;

  void increment() => setState(() {
        count++;
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: InkWell(
              onTap: () {
                increment();
              },
              child: Text('Count: $count'))),
    );
  }
}

// ==========================================
// ЗАДАЧА 2
// ==========================================
class Task2 extends StatelessWidget {
  const Task2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('Header'),
        Expanded(
          child: ListView.builder(
            itemCount: 10,
            itemBuilder: (context, index) => Text('Item $index'),
          ),
        ),
      ],
    );
  }
}

// ==========================================
// ЗАДАЧА 3
// ==========================================
class Task3 extends StatefulWidget {
  const Task3({Key? key}) : super(key: key);
  @override
  State<Task3> createState() => _Task3State();
}

class _Task3State extends State<Task3> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
}

// ==========================================
// ЗАДАЧА 4
// ==========================================
class Task4 extends StatelessWidget {
  const Task4({Key? key}) : super(key: key);

  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return "Data loaded";
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: fetchData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return Text(snapshot.data ?? 'Error');
      },
    );
  }
}

// ==========================================
// ЗАДАЧА 5
// ==========================================
class Task5 extends StatefulWidget {
  const Task5({Key? key}) : super(key: key);
  @override
  State<Task5> createState() => _Task5State();
}

class _Task5State extends State<Task5> {
  Future<void> saveAndNavigate() async {
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: saveAndNavigate,
      child: const Text('Save'),
    );
  }
}

// ==========================================
// ЗАДАЧА 6
// ==========================================
class Task6 extends StatelessWidget {
  const Task6({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.info),
        const Text(
            'Очень длинный текст, который точно не поместится в одну строку на экране мобильного устройства и вызовет ошибку RenderFlex overflowed.'),
      ],
    );
  }
}

// ==========================================
// ЗАДАЧА 7
// ==========================================
class Task7 extends StatefulWidget {
  const Task7({Key? key}) : super(key: key);
  @override
  State<Task7> createState() => _Task7State();
}

class _Task7State extends State<Task7> {
  String data = "Loading";

  @override
  void initState() async {
    super.initState();
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      data = "Loaded";
    });
  }

  @override
  Widget build(BuildContext context) => Text(data);
}

// ==========================================
// ЗАДАЧА 8
// ==========================================
class Task8 extends StatefulWidget {
  const Task8({Key? key}) : super(key: key);
  @override
  State<Task8> createState() => _Task8State();
}

class _Task8State extends State<Task8> {
  late Size screenSize;

  @override
  void initState() {
    super.initState();
    screenSize = MediaQuery.of(context).size;
  }

  @override
  Widget build(BuildContext context) => Text('Width: ${screenSize.width}');
}

// ==========================================
// ЗАДАЧА 9
// ==========================================
class Task9 extends StatefulWidget {
  const Task9({Key? key}) : super(key: key);
  @override
  State<Task9> createState() => _Task9State();
}

class _Task9State extends State<Task9> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isActive,
      onChanged: (val) {
        isActive = val;
      },
    );
  }
}

// ==========================================
// ЗАДАЧА 10
// ==========================================
class Task10 extends StatelessWidget {
  const Task10({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: List.generate(10000, (index) => Text('Item $index')),
    );
  }
}

// ==========================================
// ЗАДАЧА 11
// ==========================================
class Task11 extends StatelessWidget {
  const Task11({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => print('Tapped!'),
      child: Container(
        width: 200,
        height: 200,
      ),
    );
  }
}

// ==========================================
// ЗАДАЧА 12
// ==========================================
class Task12 extends StatefulWidget {
  const Task12({Key? key}) : super(key: key);
  @override
  State<Task12> createState() => _Task12State();
}

class _Task12State extends State<Task12> {
  @override
  void initState() {
    super.initState();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Hello')),
    );
  }

  @override
  Widget build(BuildContext context) => const Scaffold();
}

// ==========================================
// ЗАДАЧА 13
// ==========================================
class Task13 extends StatefulWidget {
  const Task13({Key? key}) : super(key: key);
  @override
  State<Task13> createState() => _Task13State();
}

class _Task13State extends State<Task13> {
  @override
  void initState() {
    print('Init');
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}

// ==========================================
// ЗАДАЧА 14
// ==========================================
class Task14 extends StatelessWidget {
  const Task14({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Expanded(
          child: Container(color: Colors.red),
        ),
      ],
    );
  }
}

// ==========================================
// ЗАДАЧА 15
// ==========================================
class Task15 extends StatefulWidget {
  const Task15({Key? key}) : super(key: key);
  @override
  State<Task15> createState() => _Task15State();
}

class _Task15State extends State<Task15> {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this as TickerProvider, duration: const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}

// ==========================================
// ЗАДАЧА 16
// ==========================================
class Task16 extends StatefulWidget {
  const Task16({Key? key}) : super(key: key);
  @override
  State<Task16> createState() => _Task16State();
}

class _Task16State extends State<Task16> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print('Tick');
    });
  }

  @override
  Widget build(BuildContext context) => const SizedBox();
}

// ==========================================
// ЗАДАЧА 17
// ==========================================
class Task17 extends StatelessWidget {
  String title;

  Task17({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title);
  }
}

// ==========================================
// ЗАДАЧА 18
// ==========================================
class Task18 extends StatelessWidget {
  final List<String> items = ['A', 'B', 'C'];

  Task18({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Text(items[index]);
      },
    );
  }
}

// ==========================================
// ЗАДАЧА 19
// ==========================================
class Task19 extends StatefulWidget {
  const Task19({Key? key}) : super(key: key);
  @override
  State<Task19> createState() => _Task19State();
}

class _Task19State extends State<Task19> {
  List<Color> colors = [Colors.red, Colors.green, Colors.blue];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: colors.map((color) {
        return _ColorBox(color: color);
      }).toList(),
    );
  }
}

class _ColorBox extends StatefulWidget {
  final Color color;
  const _ColorBox({required this.color});
  @override
  State<_ColorBox> createState() => _ColorBoxState();
}

class _ColorBoxState extends State<_ColorBox> {
  @override
  Widget build(BuildContext context) =>
      Container(color: widget.color, height: 50, width: 50);
}

// ==========================================
// ЗАДАЧА 20
// ==========================================
class Task20 extends StatelessWidget {
  const Task20({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const Scaffold()));
    return const SizedBox();
  }
}

// ==========================================
// ЗАДАЧА 21
// ==========================================
class Task21 extends StatelessWidget {
  const Task21({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        appBar: AppBar(title: const Text('Nested')),
        body: const Text('Hello'),
      ),
    );
  }
}

// ==========================================
// ЗАДАЧА 22
// ==========================================
class Task22 extends StatelessWidget {
  const Task22({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: double.infinity,
          color: Colors.blue,
        ),
      ],
    );
  }
}

// ==========================================
// ЗАДАЧА 23
// ==========================================
class Task23 extends StatelessWidget {
  const Task23({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Positioned(
        top: 10,
        child: Text('Hello'),
      ),
    );
  }
}

// ==========================================
// ЗАДАЧА 24
// ==========================================
class Task24 extends StatelessWidget {
  const Task24({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int result = 0;
    for (int i = 0; i < 1000000000; i++) {
      result += i;
    }
    return Text('Result: $result');
  }
}

// ==========================================
// ЗАДАЧА 25
// ==========================================
class Task25 extends StatefulWidget {
  const Task25({Key? key}) : super(key: key);
  @override
  State<Task25> createState() => _Task25State();
}

class _Task25State extends State<Task25> {
  String text = "Start";

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      text = "Loaded";
    });
  }

  @override
  Widget build(BuildContext context) => Text(text);
}

// ==========================================
// ЗАДАЧА 26
// ==========================================
class Task26 extends StatelessWidget {
  const Task26({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: const Center(child: Text('Hello')),
      ),
    );
  }
}

// ==========================================
// ЗАДАЧА 27
// ==========================================
class Task27 extends StatefulWidget {
  const Task27({Key? key}) : super(key: key);
  @override
  State<Task27> createState() => _Task27State();
}

class _Task27State extends State<Task27> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: _scrollController,
      children: const [Text('Item 1')],
    );
  }
}

// ==========================================
// ЗАДАЧА 28
// ==========================================
class Task28 extends StatelessWidget {
  const Task28({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFFFFF),
      width: 100,
      height: 100,
    );
  }
}

// ==========================================
// ЗАДАЧА 29
// ==========================================
class Task29 extends StatelessWidget {
  const Task29({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      child: InkWell(
        onTap: () {},
        child: const SizedBox(
            width: 100, height: 50, child: Center(child: Text('Button'))),
      ),
    );
  }
}

// ==========================================
// ЗАДАЧА 30
// ==========================================
class Task30 extends StatelessWidget {
  const Task30({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(5000, (index) => Text('Item $index')),
      ],
    );
  }
}
