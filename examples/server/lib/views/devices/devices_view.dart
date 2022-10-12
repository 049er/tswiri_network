import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tswiri_network/server/server_client.dart';
import 'package:tswiri_network/server/websocket_server.dart';
import 'package:tswiri_widgets/colors/colors.dart';

class DevicesView extends StatefulWidget {
  const DevicesView({Key? key}) : super(key: key);

  @override
  State<DevicesView> createState() => DevicesViewState();
}

class DevicesViewState extends State<DevicesView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          _clients(),
        ],
      ),
    );
  }

  Expanded _clients() {
    return Expanded(
      child: Card(
        color: background[600],
        child: ListView.builder(
          itemCount: Provider.of<WsManager>(context).clients.length,
          itemBuilder: (conext, index) {
            ServerClient serverClient =
                Provider.of<WsManager>(context).clients[index];
            return Card(
              child: ListTile(
                leading: const Icon(Icons.account_circle),
                title: Text(serverClient.username),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('SID: ${serverClient.session.id}'),
                    Text('UID: ${serverClient.deviceUID}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
