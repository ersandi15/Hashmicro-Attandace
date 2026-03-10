import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashmicro_test/config/app_pages.dart';
import 'package:hashmicro_test/config/app_routes.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones(); // Wajib untuk pengolahan waktu zona
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HashMicro Attendance Test',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, primarySwatch: Colors.blue),
      // Langsung arahkan ke DashboardView
      initialRoute: AppRoutes.login,
      getPages: AppPages.getPages(),
    );
  }
}
