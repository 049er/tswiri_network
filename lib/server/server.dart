import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:tswiri_network/commands/server_commands.dart';
import 'package:tswiri_network/scripts/server_key.dart';

import 'server_client.dart';

Future<ServerSocket> startServer(
    {required String? ip, required int? port}) async {
  return await ServerSocket.bind(ip ?? '192.168.1.111', port ?? 8080);
}

///WebSocketServer Instance.
class WebSocketServer with ChangeNotifier {
  ///The server socket.
  ServerSocket serverSocket;

  ///List of all connected clients.
  List<ServerClient> clients = [];

  ///The current key for adding new devices.
  String? temporaryKey;

  WebSocketServer({
    required this.serverSocket,
  }) {
    serverSocket.listen((event) {
      handleConnection(event);
    });
  }

  ///Handle an incoming connection.
  void handleConnection(Socket client) {
    log('${client.remoteAddress.address}:${client.remotePort}',
        name: 'Connection From: ');

    //Add the client to the list of clients.
    clients.add(
      ServerClient(client, webSocketServer: this),
    );
  }

  ///Distribute the message to all clients.
  void distributeMessage(ServerClient client, String message) {
    for (ServerClient c in clients) {
      if (c != client) {
        c.write("$message\n");
      }
    }
  }

  ///Remove the specified client.
  void removeClient(ServerClient client) {
    clients.remove(client);
  }

  ///Create a new temporary key for a single new device.
  String createTemporaryKey() {
    temporaryKey = generateTemporaryKey();
    return temporaryKey!;
  }

  void clearKey() {
    temporaryKey = null;
  }
}
