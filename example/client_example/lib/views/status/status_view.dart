import 'package:client_example/views/qr_code_scanner/qr_code_scanner_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tswiri_network/client/tswiri_client_mobile.dart';
import 'package:tswiri_network/model/qr_code.dart';
import 'package:tswiri_widgets/colors/colors.dart';

class StatusView extends StatefulWidget {
  const StatusView({Key? key}) : super(key: key);

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
  bool _isBusy = false;
  @override
  void initState() {
    super.initState();
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
        'Status',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
    );
  }

  Widget _body() {
    if (_isBusy) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else if (Provider.of<TswiriClientMobile>(context).isConnecting) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: Column(
          children: [
            Card(
              child: Column(
                children: [
                  _serverStatus(),
                  _serverIP(),
                ],
              ),
            ),
            Card(
              child: _connectWidget(),
            )
          ],
        ),
      );
    }
  }

  Widget _serverStatus() {
    return ListTile(
      leading: Provider.of<TswiriClientMobile>(context).isConnected()
          ? const Icon(Icons.power)
          : const Icon(Icons.power_off),
      title: Text(
        'Server Status',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Consumer<TswiriClientMobile>(
        builder: ((context, client, child) {
          return Text(
            client.socket?.port.toString() ?? 'Not Connected',
            style: Theme.of(context).textTheme.bodySmall,
          );
        }),
      ),
      trailing: Provider.of<TswiriClientMobile>(context).isConnected()
          ? IconButton(
              onPressed: () {
                Provider.of<TswiriClientMobile>(context, listen: false)
                    .disconnectFromServer();
                setState(() {});
              },
              icon: const Icon(Icons.cancel),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _serverIP() {
    return ListTile(
      leading: const Icon(Icons.cable_sharp),
      title: Text(
        'Server IP',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Consumer<TswiriClientMobile>(
        builder: ((context, client, child) {
          return Text(
            client.socket?.address.address ?? 'Not Connected',
            style: Theme.of(context).textTheme.bodySmall,
          );
        }),
      ),
    );
  }

  Widget _connectWidget() {
    return Visibility(
      visible: !Provider.of<TswiriClientMobile>(context).isConnected(),
      child: ListTile(
        leading: IconButton(
          onPressed: () async {
            setState(() {
              _isBusy = true;
            });
            await Provider.of<TswiriClientMobile>(context, listen: false)
                .connectToServer();

            setState(() {
              _isBusy = false;
            });
          },
          icon: const Icon(Icons.refresh),
        ),
        title: Text(
          'Connect',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        trailing: IconButton(
          onPressed: () async {
            QRCodeConnect? qrCodeConnect = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const QRCodeScannerView(),
              ),
            );

            if (qrCodeConnect != null && mounted) {
              setState(() {
                _isBusy = true;
              });
              bool connected =
                  await Provider.of<TswiriClientMobile>(context, listen: false)
                      .connectWithQRCode(qrCodeConnect);

              setState(() {
                _isBusy = false;
              });
            }

            setState(() {});
          },
          icon: const Icon(
            Icons.qr_code,
            color: tswiriOrange,
          ),
        ),
      ),
    );
  }
}
