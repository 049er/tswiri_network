import 'package:client_example/main.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tswiri_network/client/sunbird_client.dart';

class StatusView extends StatefulWidget {
  const StatusView({Key? key}) : super(key: key);

  @override
  State<StatusView> createState() => _StatusViewState();
}

class _StatusViewState extends State<StatusView> {
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
        ],
      ),
    );
  }

  Widget _serverStatus() {
    return ListTile(
      leading: const Icon(Icons.power),
      title: Text(
        'Server Status',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Consumer<AppClient>(
        builder: ((context, client, child) {
          return Text(
            client.socket?.port.toString() ?? 'Not Connected',
            style: Theme.of(context).textTheme.bodySmall,
          );
        }),
      ),
    );
  }

  Widget _serverIP() {
    return ListTile(
      leading: const Icon(Icons.cable_sharp),
      title: Text(
        'Server IP',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      subtitle: Consumer<AppClient>(
        builder: ((context, client, child) {
          return Text(
            client.socket?.address.address ?? 'Not Connected',
            style: Theme.of(context).textTheme.bodySmall,
          );
        }),
      ),
    );
  }
}
