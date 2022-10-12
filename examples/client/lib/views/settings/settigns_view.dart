import 'package:client/views/qr_code_scanner/qr_code_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tswiri_network/client/client.dart';
import 'package:tswiri_network/model/qr_code.dart';

class SettignsView extends StatefulWidget {
  const SettignsView({Key? key}) : super(key: key);

  @override
  State<SettignsView> createState() => SettignsViewState();
}

class SettignsViewState extends State<SettignsView> {
  @override
  void initState() {
    super.initState();
    _textEditingControllerPort.text =
        Provider.of<MobileClient>(context, listen: false).port.toString();
    _textEditingControllerIP.text =
        Provider.of<MobileClient>(context, listen: false).ip.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'settigns_view',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        children: [
          _usernameTile(),
          _serverTile(),
        ],
      ),
    );
  }

  Widget _usernameTile() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: const Icon(Icons.account_circle),
          title: TextFormField(
            initialValue: Provider.of<MobileClient>(context).username,
            onFieldSubmitted: (value) async {
              if (value.isNotEmpty) {
                Provider.of<MobileClient>(context, listen: false)
                    .updateUsername(value);
              }
            },
          ),
        ),
      ),
    );
  }

  TextEditingController _textEditingControllerIP = TextEditingController();
  TextEditingController _textEditingControllerPort = TextEditingController();

  Widget _serverTile() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                Provider.of<MobileClient>(context).connected
                    ? 'Connected'
                    : 'Disconnected',
              ),
              subtitle: Provider.of<MobileClient>(context).connected
                  ? Text(
                      '${Provider.of<MobileClient>(context).ip} : ${Provider.of<MobileClient>(context).port}')
                  : null,
              trailing: Provider.of<MobileClient>(context).connected
                  ? IconButton(
                      onPressed: () {
                        Provider.of<MobileClient>(context, listen: false)
                            .disconnect();
                      },
                      icon: const Icon(Icons.close),
                    )
                  : IconButton(
                      onPressed: () async {
                        await Provider.of<MobileClient>(context, listen: false)
                            .connect();
                      },
                      icon: const Icon(Icons.start),
                    ),
            ),
            const Divider(),
            ListTile(
              leading: Text(
                'IP',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              title: TextFormField(
                controller: _textEditingControllerIP,
                onFieldSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    await Provider.of<MobileClient>(context, listen: false)
                        .updateServerIP(value);
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              leading: Text(
                'Port',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              title: TextFormField(
                controller: _textEditingControllerPort,
                keyboardType: TextInputType.number,
                onFieldSubmitted: (value) async {
                  if (value.isNotEmpty) {
                    await Provider.of<MobileClient>(context, listen: false)
                        .updateServerPort(int.parse(value));
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'Scan QR Code',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              trailing: IconButton(
                onPressed: () async {
                  QRCodeConnect? qrCodeConnect =
                      await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const QrCodeScannerView(),
                    ),
                  );

                  if (qrCodeConnect != null) {
                    Provider.of<MobileClient>(context, listen: false)
                        .connectWithQRCode(qrCodeConnect);

                    _textEditingControllerPort.text =
                        Provider.of<MobileClient>(context, listen: false)
                            .port
                            .toString();
                    _textEditingControllerIP.text =
                        Provider.of<MobileClient>(context, listen: false)
                            .ip
                            .toString();

                    setState(() {});
                  } else {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Invalid QRCode')));
                    }
                  }
                },
                icon: const Icon(Icons.qr_code_rounded),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
