import 'package:get/get.dart';
import 'package:hashmicro_test/config/app_routes.dart';
import 'package:hashmicro_test/database/db_helpers.dart';

class ProfileController extends GetxController {
  var name = "User".obs;
  var isAdmin = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final session = await DBHelper().getUserSession();
    if (session != null) {
      name.value = session['name'] as String? ?? 'User';
      isAdmin.value = session['isAdmin'] as bool? ?? false;
    }
  }

  Future<void> handleLogout() async {
    await DBHelper().clearUserSession();
    Get.offAllNamed(AppRoutes.login);
  }
}
