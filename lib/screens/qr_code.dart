import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_pamsimas/services/auth.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRScannerPage extends StatefulWidget {
  const QRScannerPage({super.key});

  @override
  State<StatefulWidget> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends State<QRScannerPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  bool _isDialogShowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Scanner')),
      body: Column(
        children: [
          Expanded(
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Pass scanData to wherever you want
      String? resultScan = scanData.code;
      final TextEditingController textFieldController = TextEditingController();

      if (!_isDialogShowing) {
        // Check if dialog is not already showing
        _isDialogShowing =
            true; // Set flag to true to indicate dialog is showing

        // Show dialog with resultScan and TextFormField
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopScope(
              child: AlertDialog(
                title: const Text('Scanned QR Code'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(resultScan ?? 'No QR code scanned'),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: textFieldController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter something';
                        }
                        return null; // Return null if the input is valid
                      },
                      decoration: const InputDecoration(
                        labelText: 'Enter something...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      String resultScan = scanData.code ?? '';
                      String textFieldValue = textFieldController
                          .text; // Assuming you have a variable to hold the TextFormField value
                      if (textFieldValue.isEmpty) {
                        // If the TextFormField value is empty
                        EasyLoading.showError(
                            'Please enter something'); // Show error message
                        return; // Exit onPressed function early
                      }

                      EasyLoading.show();
                      Map<String, dynamic> response =
                          await AuthService.storeData(
                              resultScan, textFieldValue);
                      EasyLoading.dismiss();
                      if (response['status'] == 'success') {
                        // Data stored successfully
                        // Do something, e.g., show a success message
                        EasyLoading.showSuccess(response['msg']);
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.popAndPushNamed(context, '/home');
                      } else {
                        // Error occurred while storing data
                        // Do something, e.g., show an error message
                        EasyLoading.showError(response['msg']);
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.popAndPushNamed(context, '/home');
                      }

                      _isDialogShowing =
                          false; // Reset flag when dialog is closed
                    },
                    child: const Text('Kirim'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(
                          context, '/home'); // Close the dialog
                      _isDialogShowing =
                          false; // Reset flag when dialog is closed
                    },
                    child: const Text('Batal'),
                  ),
                ],
              ),
            );
          },
        );
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
