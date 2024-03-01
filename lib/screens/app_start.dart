import 'package:flutter/material.dart';
import 'package:flutter_pamsimas/screens/home.dart';
import 'package:flutter_pamsimas/screens/login.dart';
import 'package:flutter_pamsimas/services/auth.dart';

class AppStart extends StatelessWidget {
  const AppStart({super.key});

  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder<bool>(
      future: AuthService.checkToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While waiting for the token check, show a loading indicator
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          // Navigate to appropriate page based on token validity
          if (snapshot.hasData && snapshot.data!) {
            return const HomePage();
          } else {
            return const LoginPage();
          }
        }
      },
    );
  }
}
