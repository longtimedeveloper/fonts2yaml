import 'dart:io' as io;

class Log {
  Log._();

  static void Error(String input) {
    io.stderr.writeln('\x1B[31m$input\x1B[0m');
  }

  static void Information(String input) {
    io.stdout.writeln(input);
  }

  static void Warning(String input) {
    io.stderr.writeln('\x1B[33m$input\x1B[0m');
  }
}
