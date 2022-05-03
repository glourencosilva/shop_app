class HttpException implements Exception {
  HttpException(this.message) : super();

  final String message;

  @override
  String toString() {
    return message;
  }
}
