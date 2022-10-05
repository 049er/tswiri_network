import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tswiri_network/model/qr_code.dart';
import 'package:tswiri_network/server/server.dart';
import 'package:tswiri_widgets/colors/colors.dart';

class ConnectView extends StatefulWidget {
  const ConnectView({Key? key}) : super(key: key);

  @override
  State<ConnectView> createState() => _ConnectViewState();
}

class _ConnectViewState extends State<ConnectView> {
  bool _isAddingDevice = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _addDevice(),
          _qrCode(),
        ],
      ),
    );
  }

  Widget _addDevice() {
    return Visibility(
      visible: !_isAddingDevice,
      child: Card(
        child: ListTile(
          title: Text(
            'Connect a new device',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          trailing: IconButton(
            onPressed: () {
              setState(() {
                _isAddingDevice = true;
              });
            },
            icon: const Icon(
              Icons.qr_code,
              color: tswiriOrange,
            ),
          ),
        ),
      ),
    );
  }

  //TODO: implement auto disapear when phone connects.
  Widget _qrCode() {
    return Builder(builder: (context) {
      if (_isAddingDevice) {
        String ip = Provider.of<WebSocketServer>(context, listen: false)
            .serverSocket
            .address
            .address;

        int port = Provider.of<WebSocketServer>(context, listen: false)
            .serverSocket
            .port;

        String? key = Provider.of<WebSocketServer>(context, listen: false)
            .createTemporaryKey();

        QRCodeConnect qrCodeConnect =
            QRCodeConnect(ipAddress: ip, port: port, key: key);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Scan the qr code below to connect, it will only be valid for 1 device.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Card(
                  color: Colors.white,
                  child: BarcodeWidget(
                    margin: const EdgeInsets.all(8),
                    width: 200,
                    height: 200,
                    color: Colors.black,
                    padding: const EdgeInsets.all(8),
                    data: qrCodeConnect.barcodeRawValue(),
                    barcode: Barcode.qrCode(),
                  ),
                ),
                Text('IP: ${qrCodeConnect.ipAddress}'),
                Text('Port: ${qrCodeConnect.port}'),
                Text('key: ${qrCodeConnect.key}'),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<WebSocketServer>(
                      context,
                      listen: false,
                    ).clearKey();

                    setState(() {
                      _isAddingDevice = false;
                    });
                  },
                  child: Text(
                    'done',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
              ],
            ),
          ),
        );
      }
      return const SizedBox.shrink();
    });
  }
}
