class QRCodeConnect {
  QRCodeConnect({
    required this.ipAddress,
    required this.port,
    required this.key,
  });

  ///Server IP.
  String ipAddress;

  ///Server port;
  int port;

  ///Tempkey
  String key;

  ///The barcodesRawValue
  String barcodeRawValue() {
    return '$ipAddress:$port,$key';
  }

  ///Creates a QRCodeConnect from barcodeRawValue (String).
  factory QRCodeConnect.fromBarcodeRawValue(String value) {
    String key = value.split(',').last;
    String ip = value.split(',').first.split(':').first;
    int p = int.parse(value.split(',').first.split(':').last);
    return QRCodeConnect(ipAddress: ip, port: p, key: key);
  }
}
