class ArgumentNullOrEmptyException implements Exception {
  ArgumentNullOrEmptyException(String parameterName) {
    message = '$parameterName was null or empty';
  }

  late final String message;

  @override
  String toString() => 'ArgumentNullOrEmptyException: $message';
}
