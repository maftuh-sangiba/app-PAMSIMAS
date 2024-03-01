import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pamsimas/screens/home.dart';
import 'package:flutter_pamsimas/screens/login.dart';
import 'package:flutter_pamsimas/screens/qr_code.dart';

import 'screens/app_start.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AppStart(),
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/qr': (context) => const QRScannerPage(),
      },
      builder: EasyLoading.init(),
    );
  }
}
