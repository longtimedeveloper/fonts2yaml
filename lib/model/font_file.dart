import 'dart:io' as io;

import 'package:fonts2yaml/infrastructure/constants.dart';
import 'package:fonts2yaml/infrastructure/path.dart';
import 'package:fonts2yaml/model/weight_style.dart';

class FontFile {
  FontFile(this.relativePathName) {
    fontFileName = Path.getFileName(relativePathName);
    fontName = Path.getFileNameWithoutExtension(relativePathName);
    fileExtension = Path.getExtension(relativePathName);

    final fontNameParts = fontName.split('-');
    fontFamily = fontNameParts[0];

    if (fontNameParts.length == 2) {
      final weightStyleText = fontNameParts[1];
      final weightStyle = WeightStyle(weightStyleText, fontName);
      fontWeightNumber = weightStyle.fontWeightNumber;
      fontStyleName = weightStyle.fontStyleName;
      fontWeightName = weightStyle.fontWeightName;
    }
  }

  late String fileExtension;
  late String fontFamily;
  late String fontFileName;
  late String fontName;
  String fontStyleName = '';
  String fontWeightName = '';
  int fontWeightNumber = 0;
  String relativePathName;

  String toYamlEntry() {
    var path = relativePathName;
    if (io.Platform.isWindows) {
      path = relativePathName.replaceAll(Constants.forwardSlash, Constants.backSlash);
    }
    return '- asset: $path';
  }
}
