class AppExceptions implements Exception {
  final String? _message;
  final String? _prefix;

  AppExceptions([this._message, this._prefix]);

  String toString() {
    return '$_prefix$_message';
  }
}

class InternetException extends AppExceptions {
  InternetException([String? message]) : super(message!, 'No Internet');
}

class RequestTimeout extends AppExceptions {
  RequestTimeout([String? message]) : super(message!, 'Request Timeout');
}
