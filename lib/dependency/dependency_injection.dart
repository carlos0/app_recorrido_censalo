import 'package:app_recorrido_mapa/dependency/notification_controller.dart';
import 'package:get/get.dart';

import 'network_controller.dart';


class DependencyInjection {
  static void init() {
    Get.put<AppUpdateController>(AppUpdateController(), permanent: true);
    Get.put<NotificationController>(NotificationController(), permanent: true);
  }

}
