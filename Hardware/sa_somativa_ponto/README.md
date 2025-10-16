# Employee Check-In App

A Flutter application for employee check-in using geolocation and biometrics.

## Features

- **Authentication**: Login with NIF (Número de Identificação Fiscal) and password.
- **Biometric Authentication**: Optional facial recognition for enhanced security.
- **Geolocation Check-In**: Employees can only check-in if within 100 meters of the workplace.
- **Check-In History**: View past check-ins with timestamps and locations.
- **Firebase Integration**: Uses Firebase Auth for authentication and Firestore for data storage.

## Installation

1. **Clone the repository**:
   ```
   git clone <repository-url>
   cd sa_somativa_ponto
   ```

2. **Install dependencies**:
   ```
   flutter pub get
   ```

3. **Configure Firebase**:
   - Set up a Firebase project at https://console.firebase.google.com/
   - Enable Authentication and Firestore.
   - Download `google-services.json` and place it in `android/app/`.
   - Update `lib/firebase_options.dart` with your Firebase configuration.

4. **Run the app**:
   ```
   flutter run
   ```

## Permissions

The app requires the following permissions:
- **Location**: To check if the employee is within the workplace radius.
- **Biometrics**: For facial recognition (optional).

Ensure these permissions are granted on the device.

## Usage

1. **Login**: Enter your NIF and password. Enable biometrics if available.
2. **Check-In**: Press the "Check In" button when within 100m of the workplace.
3. **History**: View your check-in history from the app bar.

## Workplace Location

The workplace is currently hardcoded to São Paulo, Brazil (-23.5505, -46.6333). To change:
- Update `LocationController.workplaceLatitude` and `LocationController.workplaceLongitude`.

## Testing

Run unit tests:
```
flutter test
```

Run integration tests:
```
flutter test integration_test/
```

Note: Integration tests may require mocking Firebase and location services for full functionality.

## Dependencies

- `firebase_core`: Firebase core functionality.
- `firebase_auth`: Firebase authentication.
- `cloud_firestore`: Firestore database.
- `geolocator`: Geolocation services.
- `local_auth`: Biometric authentication.
- `provider`: State management.

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Commit your changes.
4. Push to the branch.
5. Open a Pull Request.

## License

This project is licensed under the MIT License.
