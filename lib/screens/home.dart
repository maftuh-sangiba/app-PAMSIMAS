import 'package:flutter/material.dart';
import 'package:flutter_pamsimas/services/auth.dart';

import 'components/error_page_widget.dart';
import 'components/main_page_widget.dart';
import 'components/proccess_page_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool _isLoading;
  late String _errorMessage;
  late Map<String, dynamic> _userData;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    _errorMessage = '';
    _userData = {};
    _checkTokenValidity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              AuthService.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const ProccessPageWidget()
          : _errorMessage.isNotEmpty
              ? ErrorPageWidget(errorMessage: _errorMessage)
              : MainPageWidget(userData: _userData),
    );
  }

  Future<void> _checkTokenValidity() async {
    String? token = await AuthService.getToken();
    bool isfalid = await AuthService.verifyTokenValidity(token!);

    if (!isfalid) {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }

    try {
      var response = await AuthService.getUserDetail(token);

      if (response.statusCode == 200) {
        setState(() {
          _isLoading = false;
          _errorMessage = '';
          _userData = response.data;
        });
      } else {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (error) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error: $error';
        });
      }
    }
  }
}
