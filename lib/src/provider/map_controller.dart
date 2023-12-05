import 'dart:async';
import 'package:app_recorrido_mapa/src/models/department.dart';
import 'package:app_recorrido_mapa/src/models/polygon.dart';
import 'package:app_recorrido_mapa/src/provider/marker.widget.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'http_client.dart';
import 'http_response.dart';

enum Status { loading, loaded, stop }

enum TypePosition { gps, stream }

class PositionData {
  final Position _position;
  final TypePosition _type;

  PositionData(this._position, this._type);
  Position get getPosition => _position;
  TypePosition get getTypePosition => _type;
}

class MapsController extends GetxController {
  Status _status = Status.stop;
  Status get getStatus => _status;
  final List<Marker> _markers = [];
  String? _path;
  List<Marker> get markers => _markers;
  String? get getPath => _path;
  PositionData? _position;

  PositionData? get getPosition => _position;
  StreamSubscription<Position>? positionStream;

  List<PolygonModel> _polygons = [];
  List<PolygonModel> get polygons => _polygons;

  List<LatLng> _points = [];
  List<LatLng> get points => _points;

  List<PolygonModel> _area = [];
  List<PolygonModel> get area => _area;

  List<String> _ordenManz = [];
  List<String> get ordenManz => _ordenManz;
  List<int> _ordenManzInt = [];
  List<int> get ordenManzInt => _ordenManzInt;

  LatLng? imageMarkerPosition;
  

  @override
  void onClose() {
    print('on close');
    super.onClose();
  }

  void startService() async {
    var statusLocation = await Permission.location.status;
    print(statusLocation);

    if (statusLocation.isDenied) {
      PermissionStatus result = await Permission.location.request();
      if (result.isGranted) {
        checkGps();
      }
    }
    if (statusLocation.isGranted) {
      checkGps();
    }
  }

  Future<void> getLocation() async {
    Position position = await Geolocator.getCurrentPosition();
    _position = PositionData(position, TypePosition.gps);
    // getServiceStatusStream();
    update(['position']);
  }

  void checkGps() async {
    var status = await Permission.locationWhenInUse.status;
    print(status);

    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (isLocationServiceEnabled) {
      getServiceStatusStream();
    } else {
      await Geolocator.getCurrentPosition();
      getServiceStatusStream();
    }
  }

  void getServiceStatusStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: 0,
    );
    positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position? position) {
      if (position != null) {
        _position = PositionData(position, TypePosition.stream);
        update(['position']);
      }
    });
  }

  getPolygons(String segmentoId) async {
    HttpResponse response =
        await HttpClient.instance.get('api/v1/ruta/buscar/$segmentoId');
    if (response.data != null) {
      var polygons = response.data['rutas'];
      var points = response.data['points'];
      var area = response.data['areas'];
      _polygons = [];
      _points = [];
      _area = [];
      _ordenManz = [];
      _ordenManzInt = [];
      for (var i = 0; i < points.length; i++) {
        var d = points[i]['point'];
        _points.add(LatLng(d[1], d[0]));
        _ordenManzInt.add(int.parse(points[i]['ord_pre_seg']));
      }
      for (var i = 0; i < polygons.length; i++) {
        var d = polygons[i];
        List<LatLng> latLng = [];
        latLng.add(LatLng(d[1], d[0]));
          _polygons.add(PolygonModel(latLng));
        }
      for (var i = 0; i < area.length; i++) {
        var d = area[i]['area'];
        _ordenManz.add(area[i]['orden_manz']);
        List<LatLng> latLng = [];
        for (var j = 0; j < d.length; j++) {
          latLng.add(LatLng(d[j][1], d[j][0]));
        }
        _area.add(PolygonModel(latLng));
      }
      update(['polygons']);
    }
  }

  void dispose() {
    print('dispose');
  }

  Future<void> delete() async {
    if (positionStream != null) {
      print('cancel');
      await positionStream?.cancel();
    }
  }
}
