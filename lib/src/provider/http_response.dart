class HttpResponse {
  final dynamic data;
  final HttpError? error;

  HttpResponse(this.data, this.error);

  static HttpResponse success(dynamic data) => HttpResponse(data, null);
  static HttpResponse fail(
          {required int status,
          required String message,
          required String error}) =>
      HttpResponse(null, HttpError(status, message, error));
}

class HttpError {
  final int status;
  final String message;
  final String error;

  HttpError(this.status, this.message, this.error);
}
