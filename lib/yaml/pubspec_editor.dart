import 'dart:collection';
import 'package:file/file.dart';
import 'package:fonts2yaml/infrastructure/infrastructure.dart';
import 'package:fonts2yaml/model/model.dart';

class PubspecEditor {
  PubspecEditor(this.fs);

  FileSystem fs;

  void run(Fonts2YamlRequest fonts2YamlRequest, UnmodifiableListView<String> yamlLines) {
    if (yamlLines.isEmpty) {
      throw ArgumentNullOrEmptyException('yamlLines');
    }

    final _pubspecEditor = _PubspecEditor(fs);
    _pubspecEditor.run(fonts2YamlRequest, yamlLines);
  }
}

class _PubspecEditor {
  _PubspecEditor(this.fs);

  FileSystem fs;

  PubspecYamlSectionLocations getPubspecYamlSectionLocations(List<String> fontFreeLines) {
    var lineNumber = 0;
    var assetsSectionFound = false;
    var assetsSectionEnded = false;

    var pubspecYamlSectionLocations = PubspecYamlSectionLocations();

    for (var line in fontFreeLines) {
      lineNumber += 1;
      if (line.startsWith('flutter:')) {
        pubspecYamlSectionLocations.setFlutterSection(lineNumber);
        continue;
      }

      if (line.startsWith('  uses-material-design')) {
        pubspecYamlSectionLocations.setUsesMaterialDesignEntry(lineNumber);
        continue;
      }

      if (line.startsWith('  assets:')) {
        assetsSectionFound = true;
        continue;
      }

      if (assetsSectionFound && !assetsSectionEnded) {
        if (isEndOfSection(line)) {
          assetsSectionEnded = true;
          pubspecYamlSectionLocations.setAssetsSectionEnds(lineNumber);
        }
      }
    }
    if (assetsSectionFound && pubspecYamlSectionLocations.assetsSectionEnds == 0) {
      pubspecYamlSectionLocations.setAssetsSectionEnds(lineNumber);
    }
    return pubspecYamlSectionLocations;
  }

  bool isEndOfSection(String line) {
    if (line.trimLeft().startsWith('#')) {
      return true;
    }
    if (line.length > 2 && line.startsWith('  ') && line[2].isLetter()) {
      return true;
    }
    return false;
  }

  void makeBackupCopyOfPubspecYaml(Fonts2YamlRequest fonts2YamlRequest) {
    final backupFileName = Path.combine([fonts2YamlRequest.rootFolderName, 'pubspec.bak.yaml']);
    fs.file(fonts2YamlRequest.pubspecYamlFileName).copySync(backupFileName);
  }

  List<String> removeCurrentFontSection(List<String> yamlLines) {
    final fontFreeLines = <String>[];
    var fontSectionFound = false;
    var fontSectionEnded = false;

    for (var line in yamlLines) {
      if (fontSectionFound && !fontSectionEnded) {
        if (isEndOfSection(line)) {
          fontSectionEnded = true;
          fontFreeLines.add(line);
        }
        continue;
      }
      if (line.startsWith('  fonts:')) {
        fontSectionFound = true;
        continue;
      }
      fontFreeLines.add(line);
    }

    return fontFreeLines;
  }

  void run(Fonts2YamlRequest fonts2YamlRequest, UnmodifiableListView<String> yamlLines) {
    final pubspecLines = fs.file(fonts2YamlRequest.pubspecYamlFileName).readAsLinesSync();
    final fontFreeLines = removeCurrentFontSection(pubspecLines);
    final pubspecYamlSectionLocations = getPubspecYamlSectionLocations(fontFreeLines);
    final fontYamlInsertAtLineNumber = pubspecYamlSectionLocations.getFontYamlInsertAtLineNumber();

    if (fontYamlInsertAtLineNumber == 0) {
      Log.Error('');
      Log.Error('Invalid pubspec.yaml file, no flutter section found.');
      Log.Error('');
      return;
    }

    final modifiedYamlLines = yamlLines.toList();
    if (fontFreeLines.last.isNotEmpty) {
      modifiedYamlLines.insert(0, '');
    }
    modifiedYamlLines.add('');

    final finalLines = <String>[];
    finalLines.addAll(fontFreeLines);
    finalLines.insertAll(fontYamlInsertAtLineNumber, modifiedYamlLines);
    makeBackupCopyOfPubspecYaml(fonts2YamlRequest);
    final pubspecText = finalLines.join('\n');
    fs.file(fonts2YamlRequest.pubspecYamlFileName).writeAsStringSync(pubspecText.trimLeft(), flush: true);

    Log.Information('');
    Log.Information('pubspec.yaml updated.');
    Log.Information('');
  }
}
