import 'dart:convert';
import 'dart:io';

import 'package:tswiri_network/events/posts.dart';
import 'package:tswiri_network/events/requests.dart';
import 'package:tswiri_network/server/ws_server/ws_Manager.dart';

class WsClient {
  //Websocket
  WebSocket ws;

  //WebSocket Manager
  WsManager wsManager;

  //Devices UID.
  String? deviceUID;

  late Request r = Request(ws);
  late Post p = Post(ws);

  WsClient({
    required this.ws,
    required this.wsManager,
  }) {
    _init();
  }

  _init() {
    r.requestDeviceUID();

    ws.listen(
      (event) => _onEvent(event),
      onError: (error) => _onError(error),
      onDone: () => _onDone(),
    );
  }

  _onEvent(event) {
    List data = List.from(json.decode(event));
    String identifier = data[0];
    switch (identifier) {
      case 'r':
        _handleRequest(data);
        break;
      case 'p':
        _handlePost(data);
        break;
      default:
    }
  }

  _handleRequest(List r) {
    print('Request: ' + r.toString());
    Requests request = Requests.values.byName(r[1]);
    switch (request) {
      case Requests.deviceUID:
        break;
      default:
    }
  }

  _handlePost(List p) {
    print('Post: ' + p.toString());
    Posts post = Posts.values.byName(p[1]);
    switch (post) {
      case Posts.deviceUID:
        //Set device's UID.
        deviceUID = p[2];

        //Request Database info.
        r.requestDatabaseInfo();

        break;
      case Posts.databaseInfo:
        print(p[2]);
        break;
      default:
    }
  }

  _onError(error) {
    print(error);
  }

  _onDone() {
    wsManager.removeClient(this);
  }
}
