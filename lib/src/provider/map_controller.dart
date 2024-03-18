import 'package:app_recorrido_mapa/src/models/polygon.dart';
import 'package:app_recorrido_mapa/src/screens/home_screen.dart';
import 'package:app_recorrido_mapa/src/services/connectivity_service.dart';
import 'package:app_recorrido_mapa/src/utils/alert.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';

import 'http_client.dart';
import 'http_response.dart';

enum Status { loading, loaded, stop }

enum TypePosition { gps, stream }

class MapsController extends GetxController {
  final box = GetStorage();
  final Status _status = Status.stop;
  Status get getStatus => _status;
  final List<Marker> _markers = [];
  String? _path;
  List<Marker> get markers => _markers;
  String? get getPath => _path;
  String? _seg_unico;
  String? get getSegUnico => _seg_unico;

  List<PolygonModel> _polygons = [];
  List<PolygonModel> get polygons => _polygons;

  List<LatLng> _points = [];
  List<LatLng> get points => _points;

  List<PolygonModel> _area = [];
  List<PolygonModel> get area => _area;

  List<String> _ordenManz = [];
  List<String> get ordenManz => _ordenManz;
  List<dynamic> _puntoManz = [];
  List<dynamic> get puntoManz => _puntoManz;
  List<int> _ordenManzInt = [];
  List<int> get ordenManzInt => _ordenManzInt;
  List<String> get mensajeManz => _mensajeManz;
  List<String> _mensajeManz = [];
 
  LatLng? imageMarkerPosition;

  @override
  void onClose() {
    print('on close');
    super.onClose();
  }

  getPolygons(String segmentoId) async {
    bool connectivity = ConnectivityService().isConnected;
    print(box.read('envio'));
    if (connectivity && box.read('envio') == 1) {
      box.write('envio', 2);
      HttpResponse response = await HttpClient.instance.get('api/v1/ruta/buscar/$segmentoId');
      if (response.data != null) {
        var polygons = response.data['rutas'];
        var points = response.data['points'];
        var area = response.data['areas'];
        _polygons = [];
        _points = [];
        _area = [];
        _ordenManz = [];
        _puntoManz = [];
        _ordenManzInt = [];
        _mensajeManz = [];
        _seg_unico = response.data['seg_unico'];
        box.write('seg_unico', _seg_unico);
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
          _puntoManz.add(LatLng(area[i]['punto_medio'][1], area[i]['punto_medio'][0]));
          _mensajeManz.add(area[i]['mensaje']);
          List<LatLng> latLng = [];
          for (var j = 0; j < d.length; j++) {
            latLng.add(LatLng(d[j][1], d[j][0]));
          }
          _area.add(PolygonModel(latLng));
        }

        update(['polygons']);

        box.write('polygons', polygons);
        box.write('areas', area);
        box.write('points', points);
      } else {
        //Get.to(() => const HomeScreen());
       // Navigator.pop(context);
        Alert.error('No se encontraron datos');
      }
    } else {
      var polygons = box.read('polygons');
      var points = box.read('points');
      var area = box.read('areas');
      if (polygons != null && points != null && area != null) {
      _polygons = [];
      _points = [];
      _area = [];
      _ordenManz = [];
      _puntoManz = [];
      _ordenManzInt = [];
      _mensajeManz = [];
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
        _mensajeManz.add(area[i]['mensaje']);
        _puntoManz.add(LatLng(area[i]['punto_medio'][1], area[i]['punto_medio'][0]));
        List<LatLng> latLng = [];
        for (var j = 0; j < d.length; j++) {
          latLng.add(LatLng(d[j][1], d[j][0]));
        }
        _area.add(PolygonModel(latLng));
      }
      }
      //update(['polygons']);
    }
  }

  getPoligonCache() {
    var polygons = box.read('polygons');
    var points = box.read('points');
    var area = box.read('areas');
    if (polygons != null && points != null && area != null) {
      _polygons = [];
      _points = [];
      _area = [];
      _ordenManz = [];
      _puntoManz = [];
      _ordenManzInt = [];
      _mensajeManz = [];
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
        _mensajeManz.add(area[i]['mensaje']);
        _puntoManz.add(LatLng(area[i]['punto_medio'][1], area[i]['punto_medio'][0]));
        List<LatLng> latLng = [];
        for (var j = 0; j < d.length; j++) {
          latLng.add(LatLng(d[j][1], d[j][0]));
        }
        _area.add(PolygonModel(latLng));
      }
    }
  }

  void dispose() {
    print('dispose');
  }
}
