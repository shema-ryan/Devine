class HttpError implements Exception {
  final dynamic message;

  HttpError({this.message});

  String toString() {
    return message;
  }
}
