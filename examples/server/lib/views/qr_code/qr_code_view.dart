import 'dart:async';
import 'dart:developer';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tswiri_network_websocket/model/qr_code.dart';
import 'package:tswiri_network_websocket/server/websocket_server.dart';

class QrCodeView extends StatefulWidget {
  const QrCodeView({Key? key}) : super(key: key);

  @override
  State<QrCodeView> createState() => QrCodeViewState();
}

class QrCodeViewState extends State<QrCodeView> {
  Timer? timer;
  int count = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Builder(builder: (context) {
        if (Provider.of<WsManager>(context).tempKey != null &&
            Provider.of<WsManager>(context).wsServerOnline) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _qrCode(),
            ],
          );
        } else {
          return Column(
            children: [
              _newDevice(),
            ],
          );
        }
      }),
    );
  }

  Widget _newDevice() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.phone_android),
        title: Text(
          'New device',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: IconButton(
          onPressed: () {
            Provider.of<WsManager>(context, listen: false).createTemporaryKey();

            count = Provider.of<WsManager>(context, listen: false).validTime;
            timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              count--;
              log(count.toString());
              setState(() {});
              if (count == 0) {
                timer.cancel();
              }
            });
          },
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _qrCode() {
    String ip = Provider.of<WsManager>(context).wsServer!.address.address;
    String key = Provider.of<WsManager>(context).tempKey!;
    int port = Provider.of<WsManager>(context).wsServer!.port;
    int maxTime = Provider.of<WsManager>(context, listen: false).validTime;

    return Column(
      children: [
        Card(
          color: Colors.white,
          child: BarcodeWidget(
            margin: const EdgeInsets.all(8),
            width: 300,
            height: 300,
            color: Colors.black,
            padding: const EdgeInsets.all(8),
            data: QRCodeConnect(
              ipAddress: ip,
              key: key,
              port: port,
            ).barcodeRawValue(),
            barcode: Barcode.qrCode(),
          ),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  fit: StackFit.loose,
                  children: [
                    Text(count.toString()),
                    CircularProgressIndicator(
                      value: (count / maxTime),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
