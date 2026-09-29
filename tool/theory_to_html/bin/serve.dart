import 'dart:io';

/// Мини-сервер для предпросмотра 0_html/theory.html на http://localhost:8910
void main() async {
  final root = Directory('0_html');
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 8910);
  stdout.writeln('Serving on http://localhost:8910/theory.html');
  await for (final req in server) {
    final name = req.uri.path == '/' ? '/theory.html' : req.uri.path;
    final file = File('${root.path}${name.replaceAll('/', Platform.pathSeparator)}');
    if (await file.exists()) {
      req.response.headers.contentType =
          name.endsWith('.html') ? ContentType.html : ContentType.binary;
      await req.response.addStream(file.openRead());
    } else {
      req.response.statusCode = HttpStatus.notFound;
    }
    await req.response.close();
  }
}
