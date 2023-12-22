import 'package:latlong2/latlong.dart';

class PolygonModel {
  final List<LatLng> latLng;

  PolygonModel(this.latLng);


 Map<String, dynamic> toJson() {
    return {
      'latLng': latLng.map((e) => [e.latitude, e.longitude]),
    };
  }

  
  PolygonModel fromJson(List<dynamic> json) {
    List<LatLng> latLngList = json.map((e) => LatLng(e[0], e[1])).toList();
    return PolygonModel(latLngList);
  }
}
