import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hashmicro_test/services/location_service.dart';
import 'package:hashmicro_test/features/location_master/repositories/location_repository.dart';
import 'package:hashmicro_test/features/location_master/models/location_models.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hashmicro_test/utils/ui_helpers.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();
  final nameController = TextEditingController();
  final _repository = LocationRepository();

  // State untuk menyimpan koordinat terpilih
  var selectedLat = 0.0.obs;
  var selectedLng = 0.0.obs;
  var isLoading = false.obs;

  // Di dalam LocationController
  GoogleMapController? mapController;

  @override
  void onInit() {
    super.onInit();
    // Langsung minta permission dan titik lokasi saat halaman dibuka
    pinCurrentLocation();
  }

  Future<void> pinCurrentLocation() async {
    try {
      isLoading.value = true;
      Position position =
          await _locationService.getCurrentLocation(); // Dari Service

      selectedLat.value = position.latitude;
      selectedLng.value = position.longitude;

      // Gerakkan kamera ke lokasi baru
      mapController?.animateCamera(
        CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
      );

      // Ambil nama alamat dan masukkan ke UI
      await getAddressFromCoords(position.latitude, position.longitude);
    } catch (e) {
      UIHelper.showErrorDialog(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Fungsi simpan ke SQLite
  Future<void> saveLocation() async {
    if (nameController.text.isEmpty || selectedLat.value == 0.0) {
      UIHelper.showErrorDialog(
        title: "Error",
        message: "Nama lokasi dan koordinat tidak boleh kosong",
      );
      return;
    }

    try {
      final newLocation = LocationModel(
        name: nameController.text,
        latitude: selectedLat.value,
        longitude: selectedLng.value,
      );

      await _repository.insertLocation(newLocation);
      UIHelper.showSuccessDialog(
        title: "Sukses",
        message: "Master data lokasi berhasil disimpan!",
        onConfirm: () {
          // Tutup dialog dan halaman presensi (Get back 2 kali), kembali ke Dashboard.
          Get.close(2);
        },
      );

      // Reset form setelah simpan
      nameController.clear();
    } catch (e) {
      UIHelper.showErrorDialog(
        title: "Gagal Menyimpan",
        message: "Terjadi kesalahan saat menyimpan lokasi: ${e.toString()}",
      );
    }
  }

  var address = "".obs;

  // 1. Fungsi saat peta di-klik
  void onMapTap(LatLng latLng) async {
    selectedLat.value = latLng.latitude;
    selectedLng.value = latLng.longitude;

    // Ambil alamat dari koordinat
    await getAddressFromCoords(latLng.latitude, latLng.longitude);
  }

  // 2. Fungsi Reverse Geocoding
  Future<void> getAddressFromCoords(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      Placemark place = placemarks[0];
      address.value =
          "${place.street}, ${place.subLocality}, ${place.locality}";

      // Otomatis isi TextField nama dengan nama jalan / nama gedung
      nameController.text = place.name ?? "Lokasi Baru";
    } catch (e) {
      address.value = "Alamat tidak ditemukan";
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
