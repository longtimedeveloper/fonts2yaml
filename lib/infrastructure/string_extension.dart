extension StringExtension on String {
  /// Returns true if the first English character is a lower case or upper case letter, otherwise false;
  ///
  /// If the string is empty, return false;
  bool isLetter() {
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
    return this != '' && letters.contains(this[0]);
  }

  /// Returns true if the first English character is a lower case letter, otherwise false;
  ///
  /// If the string is empty, return false;
  bool isLowerCaseLetter() {
    final letters = 'abcdefghijklmnopqrstuvwxyz';
    return this != '' && letters.contains(this[0]);
  }

  /// Returns true if the first English character is an upper case letter, otherwise false;
  ///
  /// If the string is empty, return false;
  bool isUpperCaseLetter() {
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    return this != '' && letters.contains(this[0]);
  }
}
