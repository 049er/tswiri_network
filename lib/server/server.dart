import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:tswiri_network/commands/server_commands.dart';

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

  WebSocketServer({
    required this.serverSocket,
  }) {
    serverSocket.listen((event) {
      handleConnection(event);
    });
  }

  void handleConnection(Socket client) {
    log('${client.remoteAddress.address}:${client.remotePort}',
        name: 'Connection From: ');

    //Add the client to the list of clients.
    clients.add(ServerClient(client, webSocketServer: this));

    //Request device info.
    requestDeviceInfo(client);
  }

  void distributeMessage(ServerClient client, String message) {
    for (ServerClient c in clients) {
      if (c != client) {
        c.write("$message\n");
      }
    }
  }

  void removeClient(ServerClient client) {
    clients.remove(client);
  }
}
