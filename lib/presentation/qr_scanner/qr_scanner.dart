import 'package:flutter/material.dart';
import 'package:flutter_demo_app/state/cart_state.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({super.key});

  @override
  QrScannerState createState() => QrScannerState();
}

class QrScannerState extends State<QrScanner> {
  MobileScannerController cameraController =
      MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);

  @override
  Widget build(BuildContext context) {
    return Consumer<CartState>(
      builder: (_, state, __) => Scaffold(
        body: MobileScanner(
            controller: cameraController,
            onDetect: (barcode) {
              if (barcode.barcodes.first.rawValue != null) {
                final String code = barcode.barcodes.first.rawValue!;
                state.updateDiscount(code);                        
                Navigator.of(context).pop();
              }
            }),
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }
}
