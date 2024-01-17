import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';

class AppUpdateController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    checkForUpdates();
  }

  Future<void> checkForUpdates() async {
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      // Handle errors here
    }
  }
}
