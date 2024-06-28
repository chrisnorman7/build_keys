import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:dio/dio.dart';
import 'package:html/parser.dart';

/// Build the `GameShortcutsShortcut` class.
Future<void> main() async {
  final dio = Dio();
  final response = await dio.get<String>(
    'https://api.flutter.dev/flutter/services/PhysicalKeyboardKey-class.html',
  );
  final document = parse(response.data);
  final stringBuffer = StringBuffer()
    ..writeln('// ignore_for_file: lines_longer_than_80_chars')
    ..writeln("import 'package:flutter/services.dart';")
    ..writeln('/// Hold information about [PhysicalKeyboardKey]s.')
    ..writeln('class GameShortcutsShortcut {')
    ..writeln('/// Create an instance.')
    ..writeln('const GameShortcutsShortcut({')
    ..writeln('required this.key, required this.name,});')
    ..writeln('/// The represented key.')
    ..writeln('final PhysicalKeyboardKey key;')
    ..writeln('/// The name of this key.')
    ..writeln('final String name;');
  for (final dt in document.getElementsByClassName('constant')) {
    final keyName = dt.id;
    final dl = dt.nextElementSibling!;
    final comment = dl.text.trim().replaceAll('\n', '');
    stringBuffer
      ..writeln('/// $comment')
      ..writeln(
        'static const GameShortcutsShortcut $keyName = GameShortcutsShortcut(',
      )
      ..writeln('key: PhysicalKeyboardKey.$keyName,')
      ..writeln("name: '$keyName',")
      ..writeln(');');
  }
  stringBuffer.writeln('}');
  final formatter = DartFormatter();
  final code = formatter.format(stringBuffer.toString());
  stdout.write(code);
}
