import 'package:app_recorrido_mapa/src/main_app.dart';
import 'package:app_recorrido_mapa/src/provider/map_controller.dart';
import 'package:app_recorrido_mapa/src/services/connectivity_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();   
    await FlutterMapTileCaching.initialise();
    await ConnectivityService().initialize();
  await FMTC.instance('mapStore').manage.createAsync();
  Get.put(MapsController());
  runApp(const MainApp());
  
}

