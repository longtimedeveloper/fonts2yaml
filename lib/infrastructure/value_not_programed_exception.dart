class ValueNotProgramedmException implements Exception {
  ValueNotProgramedmException(String valueName) {
    message = '$valueName was not programed.';
  }

  late final String message;

  @override
  String toString() => 'ValueNotProgramedmException: $message';
}
