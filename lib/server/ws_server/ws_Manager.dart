import 'dart:io';

import 'package:tswiri_network/server/ws_server/ws_client.dart';

class WsManager {
  WsManager({
    required this.ip,
    required this.port,
  }) {
    _init();
  }
  //IP address.
  String ip;

  //port
  int port;

  //WS Server
  HttpServer? wsServer;

  ///List of all connected clients.
  final List<WsClient> clients = [];

  ///Initiate the wsServer.
  _init() async {
    wsServer = await HttpServer.bind(ip, port, shared: true);

    wsServer!.listen((HttpRequest request) {
      switch (request.uri.path) {
        case '/ws':
          addClient(request);
          break;
        default:
      }
    });

    print('WS Server at http://${wsServer!.address.host}:${wsServer!.port}');
  }

  ///Add a newly connected client.
  addClient(HttpRequest request) async {
    WebSocket ws = await WebSocketTransformer.upgrade(request);
    WsClient serverClient = WsClient(ws: ws, wsManager: this);
    clients.add(serverClient);
  }

  ///Remove a client.
  removeClient(WsClient serverClient) {
    clients.remove(serverClient);
  }
}
