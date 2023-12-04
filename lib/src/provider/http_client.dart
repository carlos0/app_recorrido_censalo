import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'http_response.dart';

class HttpClient {
  HttpClient._internal();
  static final HttpClient _instance = HttpClient._internal();
  static HttpClient get instance => _instance;
  final Dio _dio = Dio();
  late Response onResponse;
  final String host = "http://10.16.0.212:3000";
  //"https://wc3.ine.gob.bo";
  //"http://157.230.71.198:3000";
  //"http://10.0.2.2:3000";
  //"http://3.15.196.165:3000";
  final box = GetStorage();

  init() {
    return _dio;
  }

  setUserImageData(String url) async {
    var data = box.read('user');
    data['image'] = url;
    box.write('user', data);
  }
  Future<HttpResponse> get(String url) async {
    print(2);
    print('url $host/$url');
    try {
      final token = box.read('token');
      _dio.options.headers['authorization'] = 'Bearer $token';
      final Response response = await _dio.get("$host/$url");
      return HttpResponse.success(response.data);
    } catch (e) {
      int status = -1;
      String message = 'Err';
      String error = 'Err';
      if (e is DioError) {
        message = e.message!;
        if (e.response != null) {
          status = e.response?.statusCode ?? -1;
          error = e.response?.statusMessage ?? 'err';
          message = e.response?.data['message'] ?? 'err';
        }
      }
      return HttpResponse.fail(status: status, message: message, error: error);
    }
  }

}
