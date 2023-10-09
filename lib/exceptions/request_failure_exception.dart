class RequestFailureException implements Exception {
  late String _message;

  RequestFailureException(this._message);

  String get message => _message;

  @override
  String toString() {
    return 'RequestFailureException{_message: $_message}';
  }
}
