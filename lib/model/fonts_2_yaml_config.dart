import 'dart:convert';

class Fonts2YamlConfig {
  Fonts2YamlConfig({required this.topLevelFontPaths, this.fontFileExtensions});

  factory Fonts2YamlConfig.fromJson(String source) => Fonts2YamlConfig.fromMap(json.decode(source));

  factory Fonts2YamlConfig.fromMap(Map<String, dynamic> map) {
    return Fonts2YamlConfig(
      topLevelFontPaths: List<String>.from(map['topLevelFontPaths'] ?? const []),
      fontFileExtensions: List<String>.from(map['fontFileExtensions'] ?? const []),
    );
  }

  final List<String>? fontFileExtensions;
  final List<String> topLevelFontPaths;

  Fonts2YamlConfig copyWith({
    List<String>? topLevelFontPaths,
    List<String>? fontFileExtensions,
  }) {
    return Fonts2YamlConfig(
      topLevelFontPaths: topLevelFontPaths ?? this.topLevelFontPaths,
      fontFileExtensions: fontFileExtensions ?? this.fontFileExtensions,
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'topLevelFontPaths': topLevelFontPaths,
      'fontFileExtensions': fontFileExtensions,
    };
  }
}
