import 'dart:developer';

import 'package:client/views/qr_code_scanner/qr_code_detector_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:tswiri_network_websocket/model/qr_code.dart';

import 'camera_view.dart';

class QrCodeScannerView extends StatefulWidget {
  const QrCodeScannerView({Key? key}) : super(key: key);

  @override
  State<QrCodeScannerView> createState() => QrCodeScannerViewState();
}

class QrCodeScannerViewState extends State<QrCodeScannerView> {
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
      QRCodeConnect? qrCodeConnect;

      try {
        qrCodeConnect = QRCodeConnect.fromBarcodeRawValue(barcodeRawValue);
      } catch (e) {
        log(e.toString());
      }

      Navigator.pop(context, qrCodeConnect);
    }
  }
}
