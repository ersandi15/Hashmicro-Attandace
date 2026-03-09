import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashmicro_test/config/app_routes.dart';
import 'package:hashmicro_test/utils/ui_helpers.dart';
import 'package:hashmicro_test/database/db_helpers.dart';

class LoginController extends GetxController {
  final userController = TextEditingController();
  final passController = TextEditingController();

  // Observable untuk menyimpan role di seluruh aplikasi
  var isAdmin = false.obs;
  var userName = "".obs;

  Future<void> login() async {
    String username = userController.text.trim();
    String password = passController.text.trim();

    if (username == "admin" && password == "admin123") {
      isAdmin.value = true;
      userName.value = "Admin";
      await DBHelper().saveUserSession(true, "Admin");
      Get.offNamed(AppRoutes.dashboard); // Langsung ke Dashboard
    } else if (username == "user" && password == "user123") {
      isAdmin.value = false;
      userName.value = "Ersandi";
      await DBHelper().saveUserSession(false, "Ersandi");
      Get.offNamed(AppRoutes.dashboard);
    } else {
      UIHelper.showErrorDialog(
        title: "Login Gagal",
        message: "Username atau password salah!",
      );
    }
  }

  Future<void> quickLogin({required bool isAdmin}) async {
    if (isAdmin) {
      userController.text = "admin";
      passController.text = "admin123";
    } else {
      userController.text = "user";
      passController.text = "user123";
    }

    // Langsung panggil fungsi login yang sudah kamu buat
    await login();
  }
}
