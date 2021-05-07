enum IndentLevel { one, two, three, four, five }

extension IndentLevelExtension on IndentLevel {
  String get padString {
    switch (this) {
      case IndentLevel.one:
        return ''.padLeft(2);
      case IndentLevel.two:
        return ''.padLeft(4);
      case IndentLevel.three:
        return ''.padLeft(6);
      case IndentLevel.four:
        return ''.padLeft(8);
      case IndentLevel.five:
        return ''.padLeft(10);
      default:
        throw Exception('IndentLevel value not programmed.');
    }
  }
}
