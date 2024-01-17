import 'package:get/get.dart';

import 'network_controller.dart';


class DependencyInjection {
  static void init() {
    Get.put<AppUpdateController>(AppUpdateController(), permanent: true);
  }
}
