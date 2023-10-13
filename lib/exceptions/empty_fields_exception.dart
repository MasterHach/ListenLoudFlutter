class EmptyFieldException implements Exception {

  EmptyFieldException(this._message);

  final String _message;

  String get message => _message;

  @override
  String toString() {
    return 'EmptyFieldException: $message';
  }

}