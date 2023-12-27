import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

import '../provider/map_controller.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late FollowOnLocationUpdate _followOnLocationUpdate;
  late final StreamController<double?> _followCurrentLocationStreamController;
  final box = GetStorage();
  double currentZoom = 18.49;
  LatLng? myPosition;
  String posicion = "";
  String? damagedDatabaseDeleted;
  
  MapsController mapController = Get.find<MapsController>();
  
  final MapController _controller = MapController();
  final mapController0 = MapController();
  final List<Marker> myMarkers = [];
  List<String> tilesOption = [
    'http://www.google.com/maps/vt?lyrs=s,h&x={x}&y={y}&z={z}',
    'http://www.google.com/maps/vt?lyrs=m&x={x}&y={y}&z={z}',
    'https://tile.openstreetmap.org/{z}/{x}/{y}.png'
  ];
  String? tileSelect;
  String? segmento;

  @override
  void initState() {
    super.initState();
    setState(() {
      tileSelect = tilesOption[0];
      segmento = box.read('segmento') ?? '';
    });
    _followOnLocationUpdate = FollowOnLocationUpdate.always;
    _followCurrentLocationStreamController = StreamController<double?>();
    //getCurrentLocation();
  }

  @override
  void dispose() {
    _followCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('*******************************  ');
      print('box.read(): $segmento');
      print('*******************************  ');
    //MapsController mapController = Get.find<MapsController>();
    final arg = ModalRoute.of(context)!.settings.arguments != null
        ? ModalRoute.of(context)!.settings.arguments as String
        : null;
    if (arg!.isNotEmpty) {
    mapController.getPolygons(arg);
      segmento = arg;
      print('entroi');
      box.write('segmento', arg);
    }

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: _appBar(),
        body: body(),
        floatingActionButton: buildFloatingActionButton(),
        floatingActionButtonLocation: ExpandableFab.location,
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
              height: MediaQuery.of(context).size.height * 0.12,
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                  child: Column(children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const Text(
                            'Segmento:  ',
                          ),
                          Text(
                        ' $segmento',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.5),
                      ),
                        ]
                      )
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/yellow_line.png',
                          height: 10,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      const Text('Área de trabajo'),
                      const SizedBox(
                        width: 40,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/red_line.jpg',
                          height: 10,
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      ),
                      const Text('Manzanas'),
                    ]),
                    const SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Image.asset(
                        'assets/images/verde.png',
                        height: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('P. Inicial'),
                      const SizedBox(
                        width: 15,
                      ),
                      Image.asset(
                        'assets/images/rojo.png',
                        height: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('P. Final'),
                      const SizedBox(
                        width: 15,
                      ),
                      Image.asset(
                        'assets/images/amarillo.png',
                        height: 25,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('P. intermedio'),
                    ]),
                    
                  ]),
                ),
              )),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.80,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                FlutterMap(
                  mapController: mapController0,
                  options: MapOptions(
                    //center: myPosition,
                    center: LatLng(-16.493712, -68.122341),
                    zoom: currentZoom,
                    minZoom: 10,
                    maxZoom: 18.49,
                    rotation: 0,
                    interactiveFlags: InteractiveFlag.all,
                    onPositionChanged: (MapPosition position, bool hasGesture) {
                      if (hasGesture &&
                          _followOnLocationUpdate != FollowOnLocationUpdate.never) {
                        setState(
                          () => _followOnLocationUpdate = FollowOnLocationUpdate.never,
                        );
                      }
                    },
                  ),
                  children: [
                    GetBuilder<MapsController>(
                        init: MapsController(),
                        id: 'path',
                        builder: (_) {
                          return TileLayer(
                            urlTemplate: tileSelect,
                            subdomains: const ['a', 'b', 'c'],
                            userAgentPackageName:
                                'dev.fleaflet.flutter_map.example',
                            //tileProvider: FMTC.instance('mapStore').getTileProvider(),
                          );
                        }),
                        CurrentLocationLayer(
                          followCurrentLocationStream:
                              _followCurrentLocationStreamController.stream,
                          followOnLocationUpdate: _followOnLocationUpdate,
                        ),
                    GetBuilder<MapsController>(
                        init: MapsController(),
                        id: 'polygons',
                        builder: (_) {
                          print('.area: ${_.area}');
                          if (_.area.isNotEmpty) {
                            var pll = PolygonLayer(
                              polygons: [],
                            );
                            for (var i = 0; i < _.area.length; i++) {
                              var pl = Polygon(
                                points: [],
                                isFilled: false,
                                borderColor: Colors.redAccent,
                                borderStrokeWidth: 5,
                                color: const Color.fromARGB(10, 0, 255, 0),
                              );
                              for (var j = 0;
                                  j < _.area[i].latLng.length;
                                  j++) {
                                pl.points.add(_.area[i].latLng[j]);
                              }
                              pll.polygons.add(pl);
                            }
                            return pll;
                          }
                          return CircleLayer(
                            circles: [
                              CircleMarker(
                                point: const LatLng(
                                    51.50739215592943, -0.127709825533512),
                                radius: 100,
                                useRadiusInMeter: true,
                              ),
                            ],
                          );
                        }),
                    GetBuilder<MapsController>(
                        init: MapsController(),
                        id: 'polygons',
                        builder: (_) {
                          if (_.polygons.isNotEmpty) {
                            var pll = PolylineLayer(
                              polylines: [],
                            );
                            var pl = Polyline(
                              points: [],
                              strokeWidth: 5,
                              color: Colors.yellow,
                            );
                            for (var i = 0; i < _.polygons.length; i++) {
                              for (var j = 0;
                                  j < _.polygons[i].latLng.length;
                                  j++) {
                                pl.points.add(_.polygons[i].latLng[j]);
                              }
                            }
                            pll.polylines.add(pl);

                            return pll;
                          }
                          return CircleLayer(
                            circles: [
                              CircleMarker(
                                point: LatLng(
                                    51.50739215592943, -0.127709825533512),
                                radius: 1,
                                useRadiusInMeter: true,
                              ),
                            ],
                          );
                        }), //END POLYGON
                    GetBuilder<MapsController>(
                        init: MapsController(),
                        id: 'polygons',
                        builder: (_) {
                          if (_.points.isNotEmpty) {
                            var pll = CircleLayer(
                              circles: [],
                            );
                            for (var i = 0; i < _.points.length; i++) {
                              var pl = CircleMarker(
                                point: _.points[i],
                                useRadiusInMeter: true,
                                color: _.ordenManzInt[i] == 1
                                    ? Colors.green
                                    : i + 1 == _.ordenManzInt.length ||
                                            (i + 1 != _.ordenManzInt.length &&
                                                _.ordenManzInt[i + 1] == 1)
                                        ? Colors.red
                                        : Colors.orange,
                                radius: 4.5,
                                borderStrokeWidth: 1,
                              );
                              pll.circles.add(pl);
                            }
                            Future.delayed(const Duration(seconds: 1), () {
                              mapController0.move(_.points[0], 18);
                            });
                            return pll;
                          }
                          return CircleLayer(
                            circles: [
                              CircleMarker(
                                point: const LatLng(
                                    51.50739215592943, -0.127709825533512),
                                radius: 10,
                                useRadiusInMeter: true,
                              ),
                            ],
                          );
                        }), //END CIRCLE
                    GetBuilder<MapsController>(
                        init: MapsController(),
                        id: 'polygons',
                        builder: (_) {
                          if (_.ordenManzInt.isNotEmpty) {
                            var markers = MarkerLayer(markers: []);
                            for (var i = 0; i < _.ordenManzInt.length; i++) {
                              var m = Marker(
                                point: _.points[i],
                                width: 18,
                                height: 15,
                                anchorPos: AnchorPos.exactly(Anchor(9, 8)),
                                builder: (context) => InkWell(
                                  child: Center(
                                      child: Text(
                                    '${_.ordenManzInt[i]}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  onTap: () {
                                    _.imageMarkerPosition = _.points[i];
                                    _.update(['imageMarker']);
                                  },
                                ),
                              );
                              markers.markers.add(m);
                            }
                            return markers;
                          }
                          return CircleLayer(
                            circles: [
                              CircleMarker(
                                point: const LatLng(
                                    51.50739215592943, -0.127709825533512),
                                radius: 10,
                                useRadiusInMeter: true,
                              ),
                            ],
                          );
                        }), //END CIRCLE
                    GetBuilder<MapsController>(
                        init: MapsController(),
                        id: 'polygons',
                        builder: (_) {
                          if (_.ordenManz.isNotEmpty) {
                            var markers = MarkerLayer(
                              markers: [],
                            );
                            for (var i = 0; i < _.area.length; i++) {
                              markers.markers.add(Marker(
                                  point: _.area[i].latLng[0],
                                  width: 50,
                                  height: 15,
                                  anchorPos: AnchorPos.exactly(Anchor(20, 20)),
                                  builder: (context) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black87,
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: Center(
                                          child: Text(
                                        '${_.ordenManz[i]}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12),
                                      )),
                                    );
                                  }));
                            }
                            return markers;
                          }
                          return Text('');
                        }),
                    GetBuilder<MapsController>(
                      init: MapsController(),
                      autoRemove: true,
                      id: 'imageMarker',
                      builder: (_) {
                        if (_.imageMarkerPosition != null) {
                          return MarkerLayer(
                            markers: [
                              Marker(
                                point: _.imageMarkerPosition!,
                                width: 40,
                                height: 50,
                                anchorPos: AnchorPos.exactly(Anchor(22, 5)),
                                builder: (context) {
                                  var punto =
                                      _.points.indexOf(_.imageMarkerPosition!);
                                  return Tooltip(
                                      message: 'HOLA',
                                          //'Predio ${_.ordenManzInt[punto]}',
                                      child: Image.asset(
                                          'assets/images/marker.png'));
                                },
                              ),
                            ],
                          );
                        }
                        return Container();
                      },
                    )
                  ],
                ),
                Column(children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.redAccent, //<-- SEE HERE
                    child: IconButton(
                      icon: const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        currentZoom++;
                        mapController0.move(mapController0.center, currentZoom);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.redAccent, //<-- SEE HERE
                    child: IconButton(
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        currentZoom--;
                        mapController0.move(mapController0.center, currentZoom);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.redAccent, //<-- SEE HERE
                    child: IconButton(
                      icon: const Icon(
                        Icons.my_location,
                        color: Colors.white,
                      ),
                      onPressed: () {
                         setState(
                          () => _followOnLocationUpdate = FollowOnLocationUpdate.always,
                        );
                        // Follow the location marker on the map and zoom the map to level 18.
                        _followCurrentLocationStreamController.add(18.49);
                      },
                    ),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
  AppBar _appBar() {
    return AppBar(
      centerTitle: true,
      leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushNamed(context, 'home');
          }),
      backgroundColor: Color(0xffB7241E),
      title: const Text(
        'Recorrido censal',
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  ExpandableFab buildFloatingActionButton() {
    return ExpandableFab(
      distance: 60,
      type: ExpandableFabType.side,
      openButtonBuilder: RotateFloatingActionButtonBuilder(
        child: const Icon(Icons.map),
        backgroundColor: const Color(0xffB7241E),
      ),
      closeButtonBuilder: FloatingActionButtonBuilder(
          size: 30,
          builder: (BuildContext context, void Function()? onPressed,
              Animation<double> progress) {
            return FloatingActionButton(
              onPressed: onPressed,
              backgroundColor: const Color(0xffB7241E),
              child: const Icon(
                Icons.close,
              ),
            );
          }),
      children: [
        FloatingActionButton.small(
          heroTag: "btn1",
          backgroundColor: const Color(0xffB7241E),
          child: const Tooltip(
              message: 'Mapa 1 ',
              child: Icon(
                Icons.looks_one_rounded,
              )),
          onPressed: () {
            setState(() {
              tileSelect = tilesOption[0];
            });
          },
        ),
        FloatingActionButton.small(
          heroTag: "btn2",
          backgroundColor: const Color(0xffB7241E),
          child: const Tooltip(
              message: 'Mapa 2 ',
              child: Icon(
                Icons.looks_two_rounded,
              )),
          onPressed: () {
            setState(() {
              tileSelect = tilesOption[1];
            });
          },
        ),
        FloatingActionButton.small(
          heroTag: "btn3",
          backgroundColor: const Color(0xffB7241E),
          child: const Tooltip(
              message: 'Mapa 3 ',
              child: Icon(
                Icons.looks_3_rounded,
              )),
          onPressed: () {
            setState(() {
              tileSelect = tilesOption[2];
            });
          },
        ),
      ],
    );
  }
}
