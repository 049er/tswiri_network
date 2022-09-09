import 'package:barcode_widget/barcode_widget.dart';

///This is used to connect a device to a server on a local network.
class QRCodeConnect {
  QRCodeConnect({
    required this.ipAddress,
    required this.port,
    required this.key,
  });
  String ipAddress;
  int port;
  String key;

  ///Creates a QRCodeConnect from barcodeRawValue.
  factory QRCodeConnect.fromBarcodeRawValue(String value) {
    String key = value.split(',').last;
    String ip = value.split(',').first.split(':').first;
    int p = int.parse(value.split(',').first.split(':').last);
    return QRCodeConnect(ipAddress: ip, port: p, key: key);
  }

  BarcodeWidget qrImage() {
    return BarcodeWidget(
      data: barcodeRawValue(),
      barcode: Barcode.qrCode(),
    );
  }

  ///The barcodesRawValue
  String barcodeRawValue() {
    return '$ipAddress:$port,$key';
  }
}

///Checks if the rawValue is valid.
bool isValidRawValue(String? rawValue) {
  if (rawValue != null && rawValue.isNotEmpty) {
    return true;
    // bool containsComma = rawValue.allMatches(',').length == 1;
    // bool containsColon = rawValue.allMatches(':').length == 1;
    // bool containsFullStops = rawValue.allMatches('.').isNotEmpty;
    // bool containsValidPort =
    //     int.tryParse(rawValue.split(',').first.split(':').last) != null;

    // if (containsComma &&
    //     containsColon &&
    //     containsFullStops &&
    //     containsValidPort) {
    //   return true;
    // }
  }

  return false;
}
