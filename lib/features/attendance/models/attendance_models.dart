class AttendanceModel {
  final int? id;
  final String date;
  final String time;
  final double latitude;
  final double longitude;
  final String locationName;
  final String address;
  final String status; // "Success" atau "Rejected"
  final double distance;

  AttendanceModel({
    this.id,
    required this.date,
    required this.time,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.address,
    required this.status,
    required this.distance,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'time': time,
      'latitude': latitude,
      'longitude': longitude,
      'location_name': locationName,
      'address': address,
      'status': status,
      'distance': distance,
    };
  }
}
