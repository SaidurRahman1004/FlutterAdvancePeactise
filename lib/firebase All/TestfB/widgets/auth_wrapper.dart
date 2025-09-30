import 'package:flutter/material.dart';
import '../HomeScreen.dart';
import '../LoginScreen.dart';
import '../models/app_user.dart';
import '../models/services/auth_service.dart';


class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder<AppUser?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Loading state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // User logged in
        if (snapshot.hasData && snapshot.data != null) {
          return const HomeScreen();
        }

        // User not logged in
        return const SignInScreen();
      },
    );
  }
}

