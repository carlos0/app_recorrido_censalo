import 'package:app_recorrido_mapa/src/main_app.dart';
import 'package:app_recorrido_mapa/src/provider/map_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() {
  Get.put(MapsController());
  runApp(const MainApp());
}

