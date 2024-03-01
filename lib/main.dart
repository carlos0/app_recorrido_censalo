import 'package:app_recorrido_mapa/dependency/dependency_injection.dart';
import 'package:app_recorrido_mapa/src/main_app.dart';
import 'package:app_recorrido_mapa/src/provider/map_controller.dart';
import 'package:app_recorrido_mapa/src/services/connectivity_service.dart';
import 'package:app_recorrido_mapa/src/utils/ssl_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();   
    await ConnectivityService().initialize();
          DependencyInjection.init();
  
  http.Client ioClient =
      SSLUtils.createLEClient('https://valid-isrgrootx1.letsencrypt.org/');  

  Get.put(MapsController());
  runApp(const MainApp());
  
}

/* Future<void> requestNotificationPermission() async {
  var status = await Permission.notification.request();
  var status1 = await Permission.scheduleExactAlarm.request();
  if (status != PermissionStatus.granted) {
    // Handle the case where the user does not grant permission
  }
  if (status1 != PermissionStatus.granted) {
    // Handle the case where the user does not grant permission
  }
} */

