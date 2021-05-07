import 'dart:collection';
import 'package:fonts2yaml/infrastructure/argument_null_or_empty_exception.dart';

class Fonts2YamlRequest {
  Fonts2YamlRequest({
    required this.fontFolderPaths,
    required this.trialRun,
    required this.pubspecYamlFileName,
    required this.rootFolderName,
    required this.fontFileExtensions,
  }) {
    if (fontFolderPaths.isEmpty) {
      throw ArgumentNullOrEmptyException('fontFullPaths');
    }
  }

  final List<String> fontFileExtensions;
  final UnmodifiableListView<String> fontFolderPaths;
  final String pubspecYamlFileName;
  final String rootFolderName;
  final bool trialRun;
}
