import 'dart:html';

Future<void> loadScripts(List<String> paths) async {
  await Future.wait(paths.map((path) async {
    final element = ScriptElement()..src = path;
    document.head!.append(element);
    await element.onLoad.first;
  }));
}
