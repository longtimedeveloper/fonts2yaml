class PubspecYamlSectionLocations {
  PubspecYamlSectionLocations();

  int _assetsSectionEnds = 0;
  int _flutterSection = 0;
  int _usesMaterialDesignEntry = 0;

  int get assetsSectionEnds => _assetsSectionEnds;
  int get flutterSection => _flutterSection;
  int get usesMaterialDesignEntry => _usesMaterialDesignEntry;

  int getFontYamlInsertAtLineNumber() {
    if (assetsSectionEnds > 0) {
      return assetsSectionEnds;
    }
    if (usesMaterialDesignEntry > 0) {
      return usesMaterialDesignEntry;
    }
    return flutterSection;
  }

  void setAssetsSectionEnds(int lineNumber) {
    _assetsSectionEnds = lineNumber;
  }

  void setFlutterSection(int lineNumber) {
    _flutterSection = lineNumber;
  }

  void setUsesMaterialDesignEntry(int lineNumber) {
    _usesMaterialDesignEntry = lineNumber;
  }
}
