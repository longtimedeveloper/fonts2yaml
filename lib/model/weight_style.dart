import 'package:fonts2yaml/infrastructure/log.dart';

class WeightStyle {
  WeightStyle(String weightStyle, String fontName) {
    if (weightStyle.contains(italic)) {
      fontStyleName = italic;
    }
    fontWeightName = weightStyle.replaceAll(italic, '');

    if (fontWeightName.isEmpty) {
      return;
    }

    switch (fontWeightName.toLowerCase()) {
      case 'thin':
        fontWeightNumber = 100;
        break;
      case 'extralight':
        fontWeightNumber = 200;
        break;
      case 'light':
        fontWeightNumber = 300;
        break;
      case 'regular':
        fontWeightNumber = 400;
        break;
      case 'medium':
        fontWeightNumber = 500;
        break;
      case 'semibold':
        fontWeightNumber = 600;
        break;
      case 'bold':
        fontWeightNumber = 700;
        break;
      case 'extrabold':
        fontWeightNumber = 800;
        break;
      case 'black':
        fontWeightNumber = 900;
        break;
      default:
        Log.Warning('Unknown font weight name $fontWeightName, you will have to adjust the font entry for $fontName.');
        break;
    }
  }

  static const String italic = 'Italic';

  String fontStyleName = '';
  String fontWeightName = '';
  int fontWeightNumber = 0;
}
