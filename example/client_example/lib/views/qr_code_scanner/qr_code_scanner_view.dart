import 'package:client_example/views/qr_code_scanner/qr_code_detector_painter.dart';
import 'package:client_example/views/qr_code_scanner/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:tswiri_network/model/qr_code.dart';

class QRCodeScannerView extends StatefulWidget {
  const QRCodeScannerView({Key? key}) : super(key: key);

  @override
  State<QRCodeScannerView> createState() => _QRCodeScannerViewState();
}

class _QRCodeScannerViewState extends State<QRCodeScannerView> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner(formats: [
    BarcodeFormat.qrCode,
  ]);
  bool _canProcess = true;
  bool _isBusy = false;
  CustomPaint? _customPaint;
  String? _text;

  bool _isBusy2 = false;

  @override
  void dispose() {
    _canProcess = false;
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CameraView(
      title: 'Barcode Scanner',
      customPaint: _customPaint,
      text: _text,
      onImage: (inputImage) {
        processImage(inputImage);
      },
    );
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess) return;
    if (_isBusy) return;
    if (_isBusy2) return;
    _isBusy = true;
    setState(() {
      _text = '';
    });
    final barcodes = await _barcodeScanner.processImage(inputImage);

    if (inputImage.inputImageData?.size != null &&
        inputImage.inputImageData?.imageRotation != null) {
      final painter = QRCodeDetectorPainter(
        barcodes,
        inputImage.inputImageData!.size,
        inputImage.inputImageData!.imageRotation,
        (rawValue) {
          if (!_isBusy2) {
            autoSelect(rawValue);
          }
        },
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      String text = 'Barcodes found: ${barcodes.length}\n\n';
      for (final barcode in barcodes) {
        text += 'Barcode: ${barcode.rawValue}\n\n';
      }
      _text = text;
      _customPaint = null;
    }
    _isBusy = false;
    if (mounted) {
      setState(() {});
    }
  }

  void autoSelect(String barcodeRawValue) async {
    if (_isBusy2) return;
    _isBusy2 = true;
    await Future.delayed(const Duration(milliseconds: 50));
    if (mounted) {
      Navigator.pop(
          context, QRCodeConnect.fromBarcodeRawValue(barcodeRawValue));
    }
  }
}
