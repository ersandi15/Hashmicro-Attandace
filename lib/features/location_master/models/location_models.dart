class LocationModel {
  final int? id;
  final String name;
  final String? address; // Opsional: Untuk keterangan lokasi yang lebih jelas
  final double latitude;
  final double longitude;
  final String? createdAt; // Format: DateTime.now().toIso8601String()

  LocationModel({
    this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'created_at': createdAt ?? DateTime.now().toIso8601String(),
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      id: map['id'],
      name: map['name'],
      address: map['address'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      createdAt: map['created_at'],
    );
  }
}