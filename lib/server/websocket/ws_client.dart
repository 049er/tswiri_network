import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:tswiri_database/export.dart';
import 'package:tswiri_network/events/events.dart';
import 'package:tswiri_network/server/websocket/ws_manager.dart';

class WsClient with ChangeNotifier {
  WsClient({
    required this.serverManager,
    required this.isar,
    required this.httpSession,
    required this.ws,
    required this.username,
  }) : events = Events(ws: ws) {
    log(username, name: 'Added Client');

    ///Request device_uid.
    events.request(Request.requestDeviceUID);

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
  HttpSession httpSession;

  ///Websocket.
  WebSocket ws;

  ///Isar reference.
  Isar isar;

  ///Client name.
  String username;

  ///The devices UID;
  String? deviceUID;

  ///Used to send requests.
  Events events;

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
    Request? request = identifyRequest(data[1]);
    log(' $request', name: 'Handle Request');

    switch (request) {
      case Request.databaseInfo:
        events.postDatabaseInfo(isar);
        break;
      default:
    }
  }

  _handlePost(List data) {
    Post? post = identifyPost(data[1]);
    log(' $post : ${data[2]}', name: 'Handle Post');

    switch (post) {
      case Post.deviceUID:
        _handleDeviceUID(data);
        break;
      case Post.newDeviceUID:
        _handleNewDeviceUID(data);
        break;
      case Post.databaseInfo:
        // String json = data[2];
        // DatabaseSync databaseSync = DatabaseSync(isar: isar);
        // databaseSync.databaseHashesFromJson(json);

        break;
      // case Post.deviceUID:
      //   String json = data[2];

      //   break;
      default:
    }
  }

  void _handleNewDeviceUID(List<dynamic> data) {
    deviceUID = data[2];
    String tempKey = data[3];
    if (serverManager.tempKey != null && tempKey == serverManager.tempKey) {
      serverManager.clearTemporaryKey();
    }
    serverManager.update();
    // events.request(Request.databaseInfo);
  }

  void _handleDeviceUID(List<dynamic> data) {
    deviceUID = data[2];
    serverManager.update();
    events.request(Request.databaseInfo);
  }

  _onError(error) {
    log(error);
    serverManager.removeClient(this);
  }

  _onDone() {
    serverManager.removeClient(this);
  }
}
