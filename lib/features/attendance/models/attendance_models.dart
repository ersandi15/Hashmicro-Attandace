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
  final String userName;

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
    required this.userName,
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
      'user_name': userName,
    };
  }
}
