import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _singleton = ConnectivityService._internal();

  factory ConnectivityService() {
    return _singleton;
  }

  ConnectivityService._internal();

  late bool _isConnected;
  bool get isConnected => _isConnected;

  final Connectivity _connectivity = Connectivity();

  Future<void> initialize() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _isConnected = _convertToBoolean(connectivityResult);

    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      _isConnected = _convertToBoolean(result);
    });
  }

  bool _convertToBoolean(ConnectivityResult result) {
    return result != ConnectivityResult.none;
  }
}
