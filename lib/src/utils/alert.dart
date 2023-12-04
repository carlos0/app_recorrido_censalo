import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Alert { 
  static error(String mensaje) {
    Get.snackbar(
      'Error',
      mensaje,
      colorText: Colors.white,
      backgroundColor: Colors.red,
      icon: const Icon(Icons.add_alert),
    );
  }

  static warning(String mensaje) {
    Get.snackbar(
      'Alerta',
      mensaje,
      colorText: Colors.white,
      backgroundColor: Colors.orange[700],
      icon: const Icon(Icons.add_alert),
    );
  }

  static success(String mensaje) {
    Get.snackbar(
      'Exito',
      mensaje,
      colorText: Colors.white,
      backgroundColor: Colors.green,
      icon: const Icon(Icons.check),
    );
  }
}
