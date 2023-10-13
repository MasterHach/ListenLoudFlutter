class PasswordValidationException implements Exception {

  PasswordValidationException(this._message);

  final String _message;

  String get message => _message;

  @override
  String toString() {
    return 'PasswordValidationException: $_message';
  }

}