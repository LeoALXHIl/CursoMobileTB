import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sa_somativa_ponto/main.dart';
import 'package:sa_somativa_ponto/controller/auth_controller.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    // Initialize Firebase for integration tests
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'test',
        appId: 'test',
        messagingSenderId: 'test',
        projectId: 'test',
      ),
    );
  });

  group('end-to-end test', () {
    testWidgets('app should start and show login screen', (tester) async {
      // Build the app and trigger a frame.
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthController()),
          ],
          child: const MaterialApp(
            home: AuthWrapper(),
          ),
        ),
      );

      // Wait for the widget to build
      await tester.pumpAndSettle();

      // Verify that the login screen is shown (assuming no user is logged in initially).
      expect(find.text('Entrar'), findsOneWidget);
      expect(find.text('Entre com seu NIF e senha'), findsOneWidget);
    });

    // Additional integration tests can be added here, such as testing navigation after login,
    // but they would require mocking Firebase and location services.
  });
}
