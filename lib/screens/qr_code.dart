import 'package:flutter/material.dart';
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
                      decoration: const InputDecoration(
                        labelText: 'Enter something...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.popAndPushNamed(
                          context, '/home'); // Close the dialog
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
