import 'dart:io' as io;

class Path {
  Path._();

  static String _cleanFirstPart(String firstPart) {
    if (firstPart.endsWith(io.Platform.pathSeparator)) {
      return firstPart.substring(0, firstPart.length - 1);
    }
    return firstPart;
  }

  static String _cleanPart(String part) {
    if (part.endsWith(io.Platform.pathSeparator)) {
      part = part.substring(0, part.length - 1);
    }
    if (part.startsWith(io.Platform.pathSeparator)) {
      part = part.substring(1);
    }
    return part;
  }

  static String combine(List<String> parts) {
    final cleanedParts = <String>[];
    var first = true;

    for (var part in parts) {
      if (first) {
        cleanedParts.add(_cleanFirstPart(part));
        first = false;
      } else {
        cleanedParts.add(_cleanPart(part));
      }
    }

    return cleanedParts.join(io.Platform.pathSeparator);
  }

  static String getExtension(String path) {
    final fileName = getFileName(path);
    final fileNameParts = fileName.split('.');
    return '.${fileNameParts.last}';
  }

  static String getFileName(String path) {
    final pathParts = path.split(io.Platform.pathSeparator);
    return pathParts.last;
  }

  static String getFileNameWithoutExtension(String path) {
    final fileName = getFileName(path);
    final fileNameParts = fileName.split('.');
    return fileNameParts[0];
  }
}
