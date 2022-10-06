import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tswiri_network/server/server.dart';
import 'package:tswiri_network/server/server_client.dart';
import 'package:tswiri_widgets/colors/colors.dart';

class DevicesView extends StatefulWidget {
  const DevicesView({Key? key}) : super(key: key);

  @override
  State<DevicesView> createState() => _DevicesViewState();
}

class _DevicesViewState extends State<DevicesView> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Column(
        children: [
          const Card(
            child: ListTile(
              title: Text('Conntected Devices'),
            ),
          ),
          Expanded(
            child: Card(
              color: background,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount:
                      Provider.of<WebSocketServer>(context).clients.length,
                  itemBuilder: (context, index) {
                    ServerClient client =
                        Provider.of<WebSocketServer>(context).clients[index];
                    return Card(
                      color: background[400],
                      child: ListTile(
                        leading: const Icon(Icons.phone_android),
                        title: Text(client.username ?? 'anon'),
                        subtitle: Text('UID: ${client.deviceUID}'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
