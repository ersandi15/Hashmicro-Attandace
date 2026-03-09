Flutter Attendance System - Technical Test HashMicro
This project is a Flutter-based mobile application developed for the technical assessment at HashMicro Indonesia. The application features location management (Master Data) and a GPS-based attendance system with 50-meter geofencing validation.

🛠 Features

- Location Management (Master Data): Users can add and pin specific locations on a map using Google Maps API.
- Geotagging & Reverse Geocoding: Automatically retrieves addresses when pinning a location on the map.
- GPS Attendance: Users can submit attendance based on their real-time GPS coordinates.
- 50-Meter Radius Validation: The system verifies if the user's distance is within 50 meters of the chosen master location. If the distance exceeds 50 meters, the attendance is rejected.
- Local Persistence: Stores master locations, attendance history, and user authentication sessions securely using SQLite for seamless offline data management.
- Role-Based Access: Differentiates between 'Admin' (can view global attendance history) and 'Employee' (can only view their own history).

🏗 Architecture & Tech Stack
This project follows a Modular Clean Architecture approach to ensure scalability and maintainability, a standard I have applied in previous professional projects like Humanis and Majoo Ecosystem.

- State Management: GetX (for reactive state, dependency injection, and routing).
- Database: Sqflite (Local SQLite storage).
- Maps & Location:
  - Maps_flutter for map visualization.
  - geolocator for high-accuracy GPS tracking and distance calculation.
  - geocoding for converting coordinates to readable addresses.

📂 Project Structure
Plaintext
lib/
├── database/ # Global SQLite configuration & initialization
├── dashboard/ # Main module (Attendance & Master Location)
│ ├── controllers/
│ ├── models/
│ ├── repositories/ # Data layer (Interacts with SQLite)
│ └── views/
├── services/ # Third-party wrappers (GPS & Maps Services)
└── utils/ # Helper functions (Geofencing logic)

🚀 How to Run

1. Clone the repository.
2. Add Google Maps API Key:
   For Android: Place your key in android/app/src/main/AndroidManifest.xml.
3. Install dependencies:
   Bash
   flutter pub get
4. Run the application:
   Bash
   flutter run

📝 Geofencing Logic
The core validation is handled in the LocationHelper utility, utilizing the Haversine formula via the geolocator package to ensure high-precision distance checking between the user and the master location.

Contact Information:

    - Name: Ersandi Mukhibillah (Sandi)
    - Role: Flutter Developer
    - Experience: 3 Years in Web & Mobile Development
