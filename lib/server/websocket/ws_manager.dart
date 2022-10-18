import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:tswiri_database/export.dart';
import 'package:tswiri_network/scripts/server_key.dart';
import 'package:tswiri_network/server/websocket/ws_client.dart';

class WsManager with ChangeNotifier {
  WsManager({
    required this.ip,
    required this.isar,
  });

  ///Isar reference.
  Isar isar;

  ///IP address.
  String ip;

  ///Tempkey for new device.
  String? tempKey;

  ///Time to keep tempkey. (seconds)
  int validTime = 20;

  ///List of all connected clients.
  final List<WsClient> clients = [];

  ///The ws server.
  HttpServer? wsServer;
  bool wsServerOnline = false;
  int wsPort = 8080;

  ///Start the HTTP server.
  void startServer() async {
    wsServer = await HttpServer.bind(ip, wsPort);
    wsServerOnline = true;
    notifyListeners();
    wsServer!.listen((HttpRequest request) {
      switch (request.uri.path) {
        case '/ws':
          String username = request.uri.queryParameters['username']!;
          addClient(request, username);
          notifyListeners();
          break;
        default:
      }
    });

    log('WS Server at http://${wsServer!.address.host}:${wsServer!.port}');
  }

  ///Kill the wsServer.
  void killWsServer() async {
    if (wsServer != null) {
      wsServerOnline = false;
      notifyListeners();
      await wsServer!.close(force: true);
      wsServer = null;
    }
  }

  ///Add a newly connected client.
  addClient(HttpRequest request, String username) async {
    WebSocket ws = await WebSocketTransformer.upgrade(request);
    WsClient serverClient = WsClient(
      serverManager: this,
      isar: isar,
      httpSession: request.session,
      ws: ws,
      username: username,
    );
    clients.add(serverClient);
    notifyListeners();
  }

  ///Remove a client.
  removeClient(WsClient serverClient) {
    clients.remove(serverClient);
    notifyListeners();
  }

  void update() {
    notifyListeners();
  }

  ///Create a new temporary key for a single new device.
  void createTemporaryKey() {
    tempKey = generateTemporaryKey();
    notifyListeners();
    Timer(Duration(seconds: validTime), () => clearTemporaryKey());
  }

  ///Clear the temporary key.
  void clearTemporaryKey() {
    tempKey = null;
    notifyListeners();
  }
}
