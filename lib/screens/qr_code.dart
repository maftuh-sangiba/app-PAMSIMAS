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
      String? resultScan = scanData.code;
      final TextEditingController textFieldController = TextEditingController();

      if (!_isDialogShowing) {
        _isDialogShowing = true;
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return PopScope(
              child: AlertDialog(
                title: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.shade900,
                        Colors.blue.shade700,
                        Colors.blue.shade500,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Meteran',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: const ColorScheme.light().background),
                      ),
                      Text(
                        '$resultScan',
                        style: TextStyle(
                            color: const ColorScheme.light().background),
                      ),
                    ],
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Masukan jumlah pemakaian',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: textFieldController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukan jumlah pemakaian dahulu!';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: 'Jumlah pemakaian',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      controller.stopCamera();
                      if (context.mounted) {
                        Navigator.popAndPushNamed(context, '/home');
                      }
                      _isDialogShowing = false;
                    },
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () async {
                      String resultScan = scanData.code ?? '';
                      String textFieldValue = textFieldController.text;
                      if (textFieldValue.isEmpty) {
                        EasyLoading.showError(
                            'Masukan jumlah pemakaian dahulu!');
                        return;
                      }

                      EasyLoading.show();
                      Map<String, dynamic> response =
                          await AuthService.storeData(
                              resultScan, textFieldValue);
                      EasyLoading.dismiss();
                      if (response['status'] == 'success') {
                        EasyLoading.showSuccess(response['msg']);
                        await Future.delayed(const Duration(seconds: 2));
                        controller.stopCamera();
                        if (context.mounted) {
                          Navigator.popAndPushNamed(context, '/home');
                        }
                      } else {
                        EasyLoading.showError(response['msg']);
                        await Future.delayed(const Duration(seconds: 2));
                        controller.stopCamera();
                        if (context.mounted) {
                          Navigator.popAndPushNamed(context, '/home');
                        }
                      }

                      _isDialogShowing = false;
                    },
                    child: const Text('Kirim'),
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
