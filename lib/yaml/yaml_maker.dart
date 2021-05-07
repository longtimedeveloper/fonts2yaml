import 'dart:collection';
import 'dart:io' as io;
import 'package:file/file.dart';
import 'package:fonts2yaml/infrastructure/infrastructure.dart';
import 'package:fonts2yaml/model/model.dart';

class YamlMaker {
  YamlMaker(this.fs);

  final FileSystem fs;

  UnmodifiableListView<String>? run(Fonts2YamlRequest request) {
    final _yamlMaker = _YamlMaker(fs);
    return _yamlMaker.run(request);
  }
}

class _YamlMaker {
  _YamlMaker(this.fs);

  final FileSystem fs;

  String cleanFileFullPath(String fileFullPath) {
    if (fileFullPath.startsWith(io.Platform.pathSeparator)) {
      fileFullPath = fileFullPath.replaceRange(0, 1, '');
    }
    if (io.Platform.isWindows) {
      fileFullPath = fileFullPath.replaceAll(Constants.forwardSlash, Constants.backSlash);
    }
    return fileFullPath;
  }

  List<FontFile> findAllFontFiles(Fonts2YamlRequest request) {
    final fontFiles = <FontFile>[];

    for (var dirName in request.fontFolderPaths) {
      final dir = fs.directory(Path.combine([fs.currentDirectory.path, dirName]));
      List allContents = dir.listSync(recursive: true, followLinks: false);
      for (var fileOrDirOrLink in allContents as Iterable<FileSystemEntity>) {
        if (fileOrDirOrLink is File) {
          final fileFullPath = fileOrDirOrLink.path.replaceAll(request.rootFolderName, '');
          final cleanedFileFullPath = cleanFileFullPath(fileFullPath);
          final file = FontFile(cleanedFileFullPath);
          if (request.fontFileExtensions.contains(file.fileExtension)) {
            fontFiles.add(file);
          }
        }
      }
    }

    return fontFiles;
  }

  String makeEntry(IndentLevel indentLevel, String entryText) {
    return '${indentLevel.padString}$entryText';
  }

  String makeFolderName(String targetFolderName, bool appendFontFamilyToPath, String fontFileName, String fontFamily) {
    if (appendFontFamilyToPath) {
      return '$targetFolderName${fontFamily.toLowerCase()}/$fontFileName';
    }
    return '$targetFolderName$fontFileName';
  }

  UnmodifiableListView<String> run(Fonts2YamlRequest request) {
    final yamlLines = <String>[];

    var currentFontFamilyName = '';

    final fontFiles = findAllFontFiles(request);
    if (fontFiles.isNotEmpty) {
      yamlLines.add(makeEntry(IndentLevel.one, 'fonts:'));

      for (var ff in fontFiles) {
        if (currentFontFamilyName != ff.fontFamily) {
          yamlLines.add(makeEntry(IndentLevel.two, '- family: ${ff.fontFamily}'));
          yamlLines.add(makeEntry(IndentLevel.three, 'fonts:'));
          currentFontFamilyName = ff.fontFamily;
        }
        yamlLines.add(makeEntry(IndentLevel.four, ff.toYamlEntry()));
        if (ff.fontStyleName.isNotEmpty) {
          yamlLines.add(makeEntry(IndentLevel.five, 'style: ${ff.fontStyleName.toLowerCase()}'));
        }
        if (ff.fontWeightNumber > 0 && ff.fontWeightNumber != 500) {
          yamlLines.add(makeEntry(IndentLevel.five, 'weight: ${ff.fontWeightNumber.toString()}'));
        }
      }
    }

    return UnmodifiableListView(yamlLines);
  }
}
