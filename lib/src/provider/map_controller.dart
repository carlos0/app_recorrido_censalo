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
  List<Marker> get markers => _markers;
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


    getDepartamentMarkers();
    /*FileDownloader.downloadFile(
        url: "https://tinypng.com/images/social/website.jpg",
        name: "PANDA",
        onDownloadCompleted: (path) {
          print(path);
          //This will be the path of the downloaded file
        });*/
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

  void getDepartamentMarkers() async {
    List<DepartamentData> deps = [];
    deps.add(DepartamentData(-16.1726971, -68.446632, 'La Paz', 10000, 50000));
    deps.add(DepartamentData(-18.3452344, -68.4549143, 'Oruro', 500, 25));
    deps.add(DepartamentData(-17.4661755, -66.035133, 'Cochabamba', 45, 56));
    deps.add(DepartamentData(-17.5666252, -61.5829663, 'Santa Cruz', 59, 52));
    deps.add(DepartamentData(-20.685304, -66.9827463, 'Potosi', 452, 89));
    deps.add(DepartamentData(-21.642, -63.831, 'Tarija', 458, 25));
    deps.add(DepartamentData(-11.345, -67.258, 'Pando', 89, 89));
    deps.add(DepartamentData(-19.979, -64.226, 'Chuquisaca', 589, 45));
    deps.add(DepartamentData(-13.683, -64.995, 'Beni', 789, 456));
    for (var i = 0; i < deps.length; i++) {
      _markers.add(Marker(
          point: LatLng(deps[i].lat, deps[i].lng),
          width: 65,
          height: 55,
          builder: (_) {
            return MarkerWidget(
              woman: deps[i].woman,
              man: deps[i].man,
              name: deps[i].name,
            );
          }));
    }
    update(['deps']);
  }

  getPolygons(String segmentoId) async {
    HttpResponse response =
        await HttpClient.instance.get('api/v1/ruta/buscar/$segmentoId');
    if (response.data != null) {
      print('=============================');
      var polygons = response.data['rutas'];
      print(polygons);
      var points = response.data['points'];
      print(points);
      print('=============================');

      var area = response.data['areas'];
      _polygons = [];
      _points = [];
      _area = [];
      _ordenManz = [];
      for (var i = 0; i < points.length; i++) {
        var d = points[i]['point'];
        _points.add(LatLng(d[1], d[0]));
      }
      for (var i = 0; i < polygons.length; i++) {
        var d = polygons[i];
        List<LatLng> latLng = [];
        latLng.add(LatLng(d[1], d[0]));
          _polygons.add(PolygonModel(latLng));
        }
      /* for (var i = 0; i < area.length; i++) {
        var d = area[i]['area'];
        _ordenManz.add(area[i]['orden_manz']);
        List<LatLng> latLng = [];
        for (var j = 0; j < d.length; j++) {
          latLng.add(LatLng(d[j][1], d[j][0]));
        }
        _area.add(PolygonModel(latLng));
      } */
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
