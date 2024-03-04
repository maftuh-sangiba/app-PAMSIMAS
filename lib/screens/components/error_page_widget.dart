import 'package:flutter/material.dart';

class ErrorPageWidget extends StatelessWidget {
  const ErrorPageWidget({
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
