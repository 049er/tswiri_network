import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tswiri_network_websocket/communication/communication.dart';
import 'package:tswiri_network_websocket/server/server.dart';
import 'package:tswiri_network_websocket/server/websocket_server.dart';

class ServerClient with ChangeNotifier {
  ServerClient({
    required this.serverManager,
    required this.session,
    required this.ws,
    required this.username,
  }) : communication = Communication(ws: ws) {
    log(username, name: 'Added Client');

    ///Request device_uid.
    communication.requestDeviceUID();

    ///Listen :D
    ws.listen(
      (event) => _handleEvent(event),
      onError: (error) => _onError(error),
      onDone: () => _onDone(),
    );
  }

  ///Reference to desktop server.
  WsManager serverManager;

  ///HttpSession.
  HttpSession session;

  ///Websocket.
  WebSocket ws;

  ///Client name.
  String username;

  ///The devices UID;
  String? deviceUID;

  ///Communication class.
  Communication communication;

  ///Client registered.
  bool registered = false;

  ///Client authenticated.
  bool authenticated = false;

  ///Handle message.
  _handleEvent(event) {
    List data = List.from(json.decode(event));
    String identifier = data[0];

    switch (identifier) {
      case 'request':
        _handleRequest(data);
        break;
      case 'post':
        _handlePost(data);
        break;
      default:
    }
  }

  _handleRequest(List data) {
    String request = data[1];
    log(' $request', name: 'Handle Request');

    switch (request) {
      case '':
        break;
      default:
    }
  }

  _handlePost(List data) {
    String post = data[1];
    log(' $post : ${data[2]}', name: 'Handle Post');

    switch (post) {
      case 'device_uid':
        deviceUID = data[2];
        serverManager.update();
        break;
      case 'new_device_uid':
        deviceUID = data[2];
        String tempKey = data[3];

        if (serverManager.tempKey != null && tempKey == serverManager.tempKey) {
          serverManager.clearTemporaryKey();
        }

        serverManager.update();
        break;
      default:
    }
  }

  _onError(error) {
    log(error);
    serverManager.removeClient(this);
  }

  _onDone() {
    serverManager.removeClient(this);
  }
}
