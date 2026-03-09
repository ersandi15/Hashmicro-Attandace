import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import 'package:hashmicro_test/utils/ui_helpers.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi controller profil
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Profil Saya"),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 55,
                backgroundColor: Colors.blueAccent,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 20),

              // Menampilkan Nama
              Obx(
                () => Text(
                  controller.name.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Menampilkan Role
              Obx(
                () => Text(
                  controller.isAdmin.value ? "Administrator" : "Employee",
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),

              const Spacer(),

              // Tombol Logout menggunakan UIHelper yang sudah dibuat
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    UIHelper.showLogoutDialog(
                      onConfirm: () => controller.handleLogout(),
                    );
                  },
                  icon: const Icon(Icons.logout, color: Colors.blueAccent),
                  label: const Text(
                    "LOGOUT",
                    style: TextStyle(color: Colors.blueAccent),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.blueAccent),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
