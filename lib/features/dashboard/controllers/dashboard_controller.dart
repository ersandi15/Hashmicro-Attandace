import 'package:get/get.dart';
import 'package:hashmicro_test/database/db_helpers.dart';

class DashboardController extends GetxController {
  var isAdmin = false.obs;
  var name = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadUserRole();
  }

  Future<void> loadUserRole() async {
    final session = await DBHelper().getUserSession();
    if (session != null) {
      isAdmin.value = session['isAdmin'] as bool? ?? false;
      name.value = session['name'] as String? ?? 'User';
    }
  }
}
