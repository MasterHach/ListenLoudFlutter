class UsernameValidationException implements Exception {

  UsernameValidationException(this._message);

  final String _message;

  String get message => _message;

  @override
  String toString() {
    return 'UsernameValidationException: $_message';
  }

}