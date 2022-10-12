import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tswiri_network/server/server.dart';
import 'package:tswiri_network/server/shelf_server.dart';
import 'package:tswiri_network/server/websocket_server.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _wsServerCard(),
          _shelfServerCard(),
        ],
      ),
    );
  }

  Card _wsServerCard() {
    return Card(
      child: ListTile(
        leading: Icon(
          Provider.of<WsManager>(context).wsServerOnline
              ? Icons.check
              : Icons.warning,
        ),
        title: Text(
          Provider.of<WsManager>(context).wsServerOnline
              ? 'Websocket Server'
              : 'Websocket Server',
        ),
        subtitle: Text(
          Provider.of<WsManager>(context).wsServerOnline
              ? 'IP: ${Provider.of<WsManager>(context).wsServer!.address.address} : ${Provider.of<WsManager>(context).wsServer!.port}'
              : '-',
        ),
        trailing: Provider.of<WsManager>(context).wsServerOnline
            ? IconButton(
                onPressed: () {
                  Provider.of<WsManager>(context, listen: false).killWsServer();
                },
                icon: const Icon(Icons.close),
              )
            : IconButton(
                onPressed: () {
                  Provider.of<WsManager>(context, listen: false).startServer();
                },
                icon: const Icon(Icons.start),
              ),
      ),
    );
  }

  Card _shelfServerCard() {
    return Card(
      child: ListTile(
        leading: Icon(
          Provider.of<ShelfManager>(context).shelfServerOnline
              ? Icons.check
              : Icons.warning,
        ),
        title: Text(
          Provider.of<ShelfManager>(context).shelfServerOnline
              ? 'Shelf Server'
              : 'Shelf Server',
        ),
        subtitle: Text(
          Provider.of<ShelfManager>(context).shelfServerOnline
              ? 'IP: ${Provider.of<ShelfManager>(context).shelfServer!.address.address} : ${Provider.of<ShelfManager>(context).shelfServer!.port}'
              : '-',
        ),
        trailing: Provider.of<ShelfManager>(context).shelfServerOnline
            ? IconButton(
                onPressed: () {
                  Provider.of<ShelfManager>(context, listen: false)
                      .killShelfServer();
                },
                icon: const Icon(Icons.close),
              )
            : IconButton(
                onPressed: () {
                  Provider.of<ShelfManager>(context, listen: false)
                      .startServer();
                },
                icon: const Icon(Icons.start),
              ),
      ),
    );
  }
}
