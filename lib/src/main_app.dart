import 'package:app_recorrido_mapa/src/screens/home_screen.dart';
import 'package:app_recorrido_mapa/src/screens/map_screen.dart';
import 'package:app_recorrido_mapa/src/screens/qr_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainApp extends StatelessWidget {
const MainApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return GetMaterialApp(
      title: 'Recorrido censal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomeScreen(),
        'qr': (context) => const QrScreen(),
        'map': (context) => const MapScreen(),
      },
    );
  }
}