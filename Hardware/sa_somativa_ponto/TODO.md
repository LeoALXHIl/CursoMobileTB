# TODO List for Flutter Employee Check-In App

## 1. Update Dependencies
- [x] Add geolocator, local_auth, cloud_firestore, provider to pubspec.yaml
- [x] Run flutter pub get

## 2. Create Models
- [x] Create lib/model/user.dart for user data
- [x] Create lib/model/checkin.dart for check-in records

## 3. Create Controllers
- [x] Create lib/controller/auth_controller.dart for authentication (NIF/password/biometrics)
- [x] Create lib/controller/location_controller.dart for geolocation checks
- [x] Create lib/controller/biometric_controller.dart for biometric auth

## 4. Update Views
- [x] Update lib/view/login_screen.dart to include NIF input, password, biometrics toggle
- [x] Create lib/view/home_screen.dart for check-in button and location status
- [x] Create lib/view/history_screen.dart for displaying check-in history

## 5. Update Main App
- [x] Update lib/main.dart to integrate provider for state management and navigation (login -> home -> history)

## 6. Implement Check-In Logic
- [x] Implement check-in logic in home_screen: get location, calculate distance, save to Firestore if within 100m

## 7. Firebase Firestore Integration
- [x] Integrate Firestore for storing check-ins in user-specific collections

## 8. Testing and Documentation
- [x] Add unit tests for controllers
- [x] Add integration tests for UI
- [x] Test on Android device/emulator (permissions for location and biometrics)
- [x] Document installation and usage
