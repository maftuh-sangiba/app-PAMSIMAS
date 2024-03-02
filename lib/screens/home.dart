import 'package:flutter/material.dart';
import 'package:flutter_pamsimas/services/auth.dart';

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
          ? const ProccessWidget()
          : _errorMessage.isNotEmpty
              ? ErrorWidget(
                  errorMessage: _errorMessage,
                )
              : MainPageWidget(
                  userData: _userData,
                ),
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
        // Token is valid, update UI with user data
        setState(() {
          _isLoading = false;
          _errorMessage = '';
          _userData = response.data;
        });
      } else {
        if (!mounted) return;
        // Invalid token, navigate to login page
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (error) {
      // Error occurred while checking token validity
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Error: $error';
        });
      }
    }
  }
}

class ProccessWidget extends StatelessWidget {
  const ProccessWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({
    super.key,
    required String errorMessage,
  }) : _errorMessage = errorMessage;

  final String _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(_errorMessage),
    );
  }
}

class MainPageWidget extends StatelessWidget {
  const MainPageWidget({
    super.key,
    required Map<String, dynamic> userData,
  }) : _userData = userData;

  final Map<String, dynamic> _userData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [
                    Colors.blue.shade900,
                    Colors.blue.shade700,
                    Colors.blue.shade500,
                  ])),
              child: Center(
                child: Text(
                  'Halo selamat datang ${_userData['user_name']}',
                  style: TextStyle(
                    color: const ColorScheme.light().background,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(colors: [
                    Colors.blue.shade900,
                    Colors.blue.shade700,
                    Colors.blue.shade500,
                  ])),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.camera_alt_rounded,
                      size: 100,
                      color: const ColorScheme.light().background,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/qr');
                      },
                      child: const Text(
                        "Scan Disini",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
