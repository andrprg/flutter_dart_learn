import 'dart:io';
import 'package:markdown/markdown.dart' as md;

/// Генерирует единый HTML-файл из всех theory.md проекта.
/// Запуск из корня репозитория:
///   dart run tool/theory_to_html/bin/generate.dart
void main() {
  final root = Directory.current;
  final outDir = Directory('${root.path}${Platform.pathSeparator}0_html');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);

  // 1. Найти все theory.md (кроме служебных папок).
  final files = <File>[];
  for (final entity in root.listSync(recursive: true)) {
    if (entity is! File) continue;
    final p = entity.path.replaceAll('\\', '/');
    if (!p.endsWith('/theory.md')) continue;
    if (p.contains('/tool/') || p.contains('/.git/')) continue;
    files.add(entity);
  }

  // 2. Сортировка: по номеру модуля, затем по пути.
  int moduleOrder(String path) {
    final name = path.replaceAll('\\', '/').split('/').firstWhere(
        (s) => RegExp(r'^\d+_').hasMatch(s),
        orElse: () => '999');
    return int.tryParse(name.split('_').first) ?? 999;
  }

  files.sort((a, b) {
    final pa = a.path.replaceAll('\\', '/');
    final pb = b.path.replaceAll('\\', '/');
    final ma = moduleOrder(pa);
    final mb = moduleOrder(pb);
    if (ma != mb) return ma.compareTo(mb);
    return pa.compareTo(pb);
  });

  // 3. Человекочитаемые имена модулей.
  const moduleNames = <String, String>{
    '1_dart_core': 'Dart Core',
    '2_dart_async': 'Dart Async',
    '3_functional_dart_with_fpdart': 'Functional Dart (fpdart)',
    '4_flutter_ui_basics': 'Flutter UI Basics',
    '5_flutter_app_skills': 'Flutter App Skills',
    '6_state_management': 'State Management',
    '7_interview_tasks': 'Interview Tasks',
    '8_prompt_engineering': 'Prompt Engineering',
    '10_mini_apps': 'Mini Apps',
  };

  String moduleKeyOf(String path) {
    final parts = path.replaceAll('\\', '/').split('/');
    return parts.firstWhere((s) => RegExp(r'^\d+_').hasMatch(s),
        orElse: () => 'other');
  }

  // 4. Конвертация каждого файла.
  final sections = <Map<String, String>>[];
  var index = 0;
  for (final file in files) {
    final rel = file.path.replaceAll('\\', '/');
    final source = file.readAsStringSync();
    final lines = source.split('\n');
    var title = lines.firstWhere((l) => l.startsWith('# '),
        orElse: () => rel).substring(2).trim();

    final bodyHtml = md.markdownToHtml(
      source,
      extensionSet: md.ExtensionSet.gitHubWeb,
      blockSyntaxes: const [],
      inlineSyntaxes: const [],
    );

    final moduleKey = moduleKeyOf(rel);
    sections.add({
      'id': 'sec-$index',
      'title': title,
      'module': moduleNames[moduleKey] ?? moduleKey,
      'moduleKey': moduleKey,
      'path': rel,
      'html': bodyHtml,
    });
    index++;
  }

  // 5. Сайдбар, сгруппированный по модулям.
  final moduleOrderKeys = <String>[];
  final byModule = <String, List<Map<String, String>>>{};
  for (final s in sections) {
    byModule.putIfAbsent(s['moduleKey']!, () {
      moduleOrderKeys.add(s['moduleKey']!);
      return [];
    }).add(s);
  }

  final nav = StringBuffer();
  for (final key in moduleOrderKeys) {
    final items = byModule[key]!;
    nav.writeln('<div class="nav-module">');
    nav.writeln(
        '<div class="nav-module-title">${items.first['module']}<span class="nav-count">${items.length}</span></div>');
    nav.writeln('<ul>');
    for (final s in items) {
      nav.writeln(
          '<li><a href="#${s['id']}" data-search="${_escapeAttr('${s['title']} ${s['module']}').toLowerCase()}">${_escapeHtml(s['title']!)}</a></li>');
    }
    nav.writeln('</ul></div>');
  }

  // 6. Контент.
  final content = StringBuffer();
  for (final s in sections) {
    content.writeln('''
<section class="topic" id="${s['id']}">
  <div class="topic-meta">
    <span class="badge">${_escapeHtml(s['module']!)}</span>
    <span class="topic-path">${_escapeHtml(s['path']!)}</span>
  </div>
  ${s['html']}
  <a class="to-top" href="#top">↑ Наверх</a>
</section>''');
  }

  final totalTopics = sections.length;
  final generated = DateTime.now().toLocal().toString().substring(0, 16);

  // 7. Сборка страницы.
  final html = buildPage(
    nav: nav.toString(),
    content: content.toString(),
    totalTopics: totalTopics,
    generated: generated,
  );

  final outFile = File('${outDir.path}${Platform.pathSeparator}theory.html');
  outFile.writeAsStringSync(html);
  stdout.writeln('OK: ${outFile.path}');
  stdout.writeln('Топиков: $totalTopics, размер: ${outFile.lengthSync()} байт');
}

String _escapeHtml(String s) => s
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;');

String _escapeAttr(String s) =>
    _escapeHtml(s).replaceAll('"', '&quot;').replaceAll("'", '&#39;');

String buildPage({
  required String nav,
  required String content,
  required int totalTopics,
  required String generated,
}) {
  return r'''<!DOCTYPE html>
<html lang="ru" data-theme="dark">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Flutter & Dart — Вся теория</title>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github-dark.min.css">
<style>
:root {
  --bg: #0d1117; --bg-soft: #161b22; --bg-code: #1c2129;
  --text: #e6edf3; --text-dim: #8b949e; --accent: #58a6ff;
  --accent2: #54b6f8; --border: #30363d; --badge: #1f6feb33;
}
[data-theme="light"] {
  --bg: #ffffff; --bg-soft: #f6f8fa; --bg-code: #f0f3f6;
  --text: #1f2328; --text-dim: #59636e; --accent: #0969da;
  --accent2: #0550ae; --border: #d1d9e0; --badge: #ddf4ff;
}
* { box-sizing: border-box; }
html { scroll-behavior: smooth; }
body {
  margin: 0; background: var(--bg); color: var(--text);
  font-family: -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
  font-size: 16px; line-height: 1.65;
}
a { color: var(--accent); text-decoration: none; }
a:hover { text-decoration: underline; }

/* ---- Layout ---- */
.layout { display: flex; min-height: 100vh; }
.sidebar {
  width: 300px; flex-shrink: 0; position: sticky; top: 0; height: 100vh;
  overflow-y: auto; background: var(--bg-soft); border-right: 1px solid var(--border);
  padding: 20px 16px 60px;
}
.main { flex: 1; min-width: 0; padding: 32px 48px 120px; max-width: 980px; }

/* ---- Sidebar ---- */
.sidebar h1 { font-size: 18px; margin: 0 0 4px; }
.sidebar .subtitle { color: var(--text-dim); font-size: 12px; margin-bottom: 14px; }
.search-box {
  width: 100%; padding: 8px 12px; margin-bottom: 16px;
  background: var(--bg); color: var(--text);
  border: 1px solid var(--border); border-radius: 8px; font-size: 14px;
}
.search-box:focus { outline: 2px solid var(--accent); outline-offset: -1px; }
.nav-module { margin-bottom: 14px; }
.nav-module-title {
  font-size: 12px; font-weight: 700; text-transform: uppercase;
  letter-spacing: .06em; color: var(--text-dim);
  display: flex; justify-content: space-between; align-items: center;
  padding: 4px 0; border-bottom: 1px solid var(--border); margin-bottom: 6px;
}
.nav-count {
  background: var(--badge); color: var(--accent);
  border-radius: 10px; padding: 0 8px; font-size: 11px;
}
.nav-module ul { list-style: none; margin: 0; padding: 0; }
.nav-module li { margin: 0; }
.nav-module a {
  display: block; padding: 5px 8px; border-radius: 6px;
  color: var(--text); font-size: 13.5px; line-height: 1.35;
  border-left: 2px solid transparent;
}
.nav-module a:hover { background: var(--badge); text-decoration: none; }
.nav-module a.active { border-left-color: var(--accent); background: var(--badge); }
li.hidden-by-search { display: none; }
.nav-module.hidden-by-search { display: none; }

/* ---- Topic ---- */
.topic {
  background: var(--bg-soft); border: 1px solid var(--border);
  border-radius: 12px; padding: 28px 36px; margin-bottom: 36px;
}
.topic-meta {
  display: flex; gap: 10px; align-items: baseline; flex-wrap: wrap;
  margin-bottom: 8px;
}
.badge {
  background: var(--badge); color: var(--accent); font-size: 12px;
  font-weight: 600; padding: 3px 10px; border-radius: 20px;
}
.topic-path { color: var(--text-dim); font-size: 12px; font-family: ui-monospace, Consolas, monospace; }
.topic h1 { font-size: 26px; margin: 6px 0 16px; padding-bottom: 10px; border-bottom: 1px solid var(--border); }
.topic h2 { font-size: 20px; margin: 28px 0 10px; color: var(--accent2); }
.topic h3 { font-size: 17px; margin: 22px 0 8px; }
.topic p { margin: 10px 0; }
.topic ul, .topic ol { padding-left: 24px; }
.topic li { margin: 4px 0; }
.topic blockquote {
  margin: 14px 0; padding: 8px 16px; color: var(--text-dim);
  border-left: 3px solid var(--accent); background: var(--badge); border-radius: 0 8px 8px 0;
}
.topic table { border-collapse: collapse; margin: 14px 0; width: 100%; font-size: 14.5px; }
.topic th, .topic td { border: 1px solid var(--border); padding: 7px 12px; text-align: left; }
.topic th { background: var(--badge); }
.topic tr:nth-child(even) td { background: #ffffff08; }
[data-theme="light"] .topic tr:nth-child(even) td { background: #00000005; }
.topic code {
  font-family: ui-monospace, "Cascadia Code", Consolas, monospace;
  font-size: 13.5px; background: var(--bg-code);
  padding: 2px 6px; border-radius: 5px;
}
.topic pre {
  background: var(--bg-code); border: 1px solid var(--border);
  border-radius: 10px; padding: 14px 16px; overflow-x: auto; margin: 14px 0;
}
.topic pre code { background: none; padding: 0; font-size: 13.5px; line-height: 1.55; }
.topic hr { border: none; border-top: 1px solid var(--border); margin: 24px 0; }
.to-top {
  display: inline-block; margin-top: 18px; font-size: 13px; color: var(--text-dim);
}
.to-top:hover { color: var(--accent); }

/* ---- Topbar & buttons ---- */
.topbar {
  position: sticky; top: 0; z-index: 10; display: flex; gap: 12px; align-items: center;
  background: var(--bg); border-bottom: 1px solid var(--border);
  padding: 10px 48px; margin: -32px -48px 28px;
}
.topbar .page-title { font-weight: 700; font-size: 15px; }
.topbar .stats { color: var(--text-dim); font-size: 13px; }
.topbar .spacer { flex: 1; }
.btn {
  background: var(--bg-soft); color: var(--text); border: 1px solid var(--border);
  border-radius: 8px; padding: 6px 12px; font-size: 13px; cursor: pointer;
}
.btn:hover { border-color: var(--accent); }
.menu-toggle { display: none; }

@media (max-width: 900px) {
  .sidebar {
    position: fixed; left: 0; top: 0; z-index: 20; height: 100vh;
    transform: translateX(-100%); transition: transform .25s ease;
    box-shadow: 0 0 40px #000a;
  }
  .sidebar.open { transform: translateX(0); }
  .menu-toggle { display: inline-block; }
  .main { padding: 20px 16px 100px; }
  .topbar { padding: 10px 16px; margin: -20px -16px 20px; }
  .topic { padding: 20px 18px; }
}
</style>
</head>
<body id="top">
<div class="layout">
  <aside class="sidebar" id="sidebar">
    <h1>Flutter & Dart</h1>
    <div class="subtitle">__TOTAL__ тем · собрано __GENERATED__</div>
    <input class="search-box" id="search" type="search" placeholder="Поиск по темам…" autocomplete="off">
    <nav id="nav">
__NAV__
    </nav>
  </aside>
  <main class="main">
    <div class="topbar">
      <button class="btn menu-toggle" id="menuToggle">☰ Темы</button>
      <span class="page-title">Вся теория курса</span>
      <span class="stats">__TOTAL__ шпаргалок</span>
      <span class="spacer"></span>
      <button class="btn" id="expandAll">Развернуть код</button>
      <button class="btn" id="themeToggle">🌙 / ☀️</button>
    </div>
__CONTENT__
  </main>
</div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/dart.min.js"></script>
<script>
// Подсветка кода
if (window.hljs) {
  document.querySelectorAll('pre code').forEach(function (block) {
    if (!block.className) block.classList.add('language-dart');
    hljs.highlightElement(block);
  });
}

// Тема
var themeBtn = document.getElementById('themeToggle');
var savedTheme = null;
try { savedTheme = localStorage.getItem('theory-theme'); } catch (e) {}
if (savedTheme) document.documentElement.setAttribute('data-theme', savedTheme);
themeBtn.addEventListener('click', function () {
  var cur = document.documentElement.getAttribute('data-theme') === 'dark' ? 'light' : 'dark';
  document.documentElement.setAttribute('data-theme', cur);
  try { localStorage.setItem('theory-theme', cur); } catch (e) {}
});

// Поиск по сайдбару
var searchInput = document.getElementById('search');
searchInput.addEventListener('input', function () {
  var q = searchInput.value.trim().toLowerCase();
  document.querySelectorAll('#nav .nav-module').forEach(function (mod) {
    var anyVisible = false;
    mod.querySelectorAll('li').forEach(function (li) {
      var a = li.querySelector('a');
      var hay = (a.getAttribute('data-search') || a.textContent).toLowerCase();
      var show = !q || hay.indexOf(q) !== -1;
      li.classList.toggle('hidden-by-search', !show);
      if (show) anyVisible = true;
    });
    mod.classList.toggle('hidden-by-search', !anyVisible);
  });
});

// Активный пункт меню при скролле
var links = Array.prototype.slice.call(document.querySelectorAll('#nav a'));
var sections = links.map(function (a) {
  return document.getElementById(a.getAttribute('href').slice(1));
});
var ticking = false;
window.addEventListener('scroll', function () {
  if (ticking) return;
  ticking = true;
  requestAnimationFrame(function () {
    var pos = window.scrollY + 120;
    var current = 0;
    for (var i = 0; i < sections.length; i++) {
      if (sections[i] && sections[i].offsetTop <= pos) current = i;
    }
    links.forEach(function (a, i) { a.classList.toggle('active', i === current); });
    ticking = false;
  });
}, { passive: true });

// Мобильное меню
var sidebar = document.getElementById('sidebar');
document.getElementById('menuToggle').addEventListener('click', function () {
  sidebar.classList.toggle('open');
});
sidebar.addEventListener('click', function (e) {
  if (e.target.tagName === 'A') sidebar.classList.remove('open');
});

// Сворачивание длинных блоков кода
document.querySelectorAll('.topic pre').forEach(function (pre) {
  if (pre.scrollHeight > 420) {
    pre.style.maxHeight = '420px';
    pre.style.overflow = 'hidden';
    pre.dataset.collapsed = '1';
    var btn = document.createElement('button');
    btn.className = 'btn';
    btn.style.margin = '4px 0 10px';
    btn.textContent = 'Показать весь код';
    btn.addEventListener('click', function () {
      var collapsed = pre.dataset.collapsed === '1';
      pre.style.maxHeight = collapsed ? 'none' : '420px';
      pre.dataset.collapsed = collapsed ? '0' : '1';
      btn.textContent = collapsed ? 'Свернуть' : 'Показать весь код';
    });
    pre.parentNode.insertBefore(btn, pre.nextSibling);
  }
});
document.getElementById('expandAll').addEventListener('click', function () {
  document.querySelectorAll('.topic pre[data-collapsed="1"]').forEach(function (pre) {
    pre.style.maxHeight = 'none';
    pre.dataset.collapsed = '0';
    if (pre.nextSibling && pre.nextSibling.tagName === 'BUTTON') {
      pre.nextSibling.textContent = 'Свернуть';
    }
  });
});
</script>
</body>
</html>
'''
      .replaceAll('__NAV__', nav)
      .replaceAll('__CONTENT__', content)
      .replaceAll('__TOTAL__', '$totalTopics')
      .replaceAll('__GENERATED__', generated);
}
