import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashmicro_test/config/app_routes.dart';
import 'package:hashmicro_test/features/attendance/views/components/menu_card_components.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F7FA,
      ), // Background abu-abu muda profesional
      appBar: AppBar(
        title: const Text(
          "HashMicro Attendance",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Selamat Datang
            const Text(
              "Halo, Ersandi!",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const Text(
              "Pilih menu untuk melanjutkan tugas hari ini",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),

            // Grid Menu
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              children: [
                MenuCardComponents(
                  title: "Master Lokasi",
                  icon: Icons.map_outlined,
                  color: Colors.blue,
                  onTap: () => Get.toNamed(AppRoutes.masterLocation), //
                ),
                MenuCardComponents(
                  title: "Absensi GPS",
                  icon: Icons.location_on_rounded,
                  color: Colors.green,
                  onTap: () => Get.toNamed(AppRoutes.attendance), //
                ),
                MenuCardComponents(
                  title: "Riwayat",
                  icon: Icons.history,
                  color: Colors.orange,
                  onTap: () => Get.toNamed(AppRoutes.history),
                ),
                MenuCardComponents(
                  title: "Profil",
                  icon: Icons.person_outline,
                  color: Colors.purple,
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
