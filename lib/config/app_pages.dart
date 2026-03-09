import 'package:get/get.dart';
import 'package:hashmicro_test/config/app_routes.dart';
import 'package:hashmicro_test/features/attendance/controllers/attendance_controller.dart';
import 'package:hashmicro_test/features/attendance/views/ui/attendance_view.dart';
import 'package:hashmicro_test/features/dashboard/views/dashboard_view.dart';
import 'package:hashmicro_test/features/location_master/controllers/location_controller.dart';
import 'package:hashmicro_test/features/location_master/views/location_master_view.dart';
import 'package:hashmicro_test/features/history/controllers/history_controller.dart';
import 'package:hashmicro_test/features/history/views/history_view.dart';

class AppPages {
  AppPages._();

  static List<GetPage> getPages() {
    return [
      GetPage(name: AppRoutes.dashboard, page: () => const DashboardView()),
      GetPage(
        name: AppRoutes.masterLocation,
        page: () => const LocationMasterView(),
        binding: BindingsBuilder(() {
          Get.put(LocationController());
        }),
      ),
      GetPage(
        name: AppRoutes.attendance,
        page: () => const AttendanceView(),
        binding: BindingsBuilder(() {
          Get.put(AttendanceController());
        }),
      ),
      GetPage(
        name: AppRoutes.history,
        page: () => const HistoryView(),
        binding: BindingsBuilder(() {
          Get.put(HistoryController());
        }),
      ),
    ];
  }
}
