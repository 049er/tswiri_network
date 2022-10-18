import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:tswiri_database/export.dart';

import 'database_sync.dart';

class Events {
  Events({
    required this.ws,
  });

  //Webscoket connection.
  WebSocket ws;

  void request(Request request) {
    switch (request) {
      case Request.requestDeviceUID:
        _requestDeviceUID();
        break;
      case Request.databaseInfo:
        _requestDatabaseInfo();
        break;
    }
  }

  _requestDatabaseInfo() {
    log('databaseInfo', name: 'Send Request');
    ws.add(json.encode(['request', requestToString(Request.databaseInfo)]));
  }

  ///Request a devices UID. (server)
  _requestDeviceUID() {
    log('requestDeviceUID', name: 'Send Request');
    ws.add(json.encode(['request', requestToString(Request.requestDeviceUID)]));
  }

  postDatabaseInfo(Isar isar) {
    log('database info', name: 'Send Post');
    ws.add(
      json.encode([
        'post',
        postToString(Post.databaseInfo),
        DatabaseSync(isar: isar).jsonHash()
      ]),
    );
  }

  ///Send device uid. (client)
  postDeviceUID(String uid) {
    log('device_uid= $uid', name: 'Send Post');
    ws.add(
      json.encode(['post', postToString(Post.deviceUID), uid]),
    );
  }

  ///Send a device UID along with the temporary key. (client)
  postNewDeviceUID(String uid, String tempKey) {
    log('device_uid= $uid : tempKey= $tempKey', name: 'Send Post');
    ws.add(
      json.encode(['post', postToString(Post.newDeviceUID), uid, tempKey]),
    );
  }

  ///Send an authentication notice. (server)
  postAuth(bool value) {
    log('Authenticated :D', name: 'Send Post');
    ws.add(
      json.encode(['post', postToString(Post.auth), value.toString()]),
    );
  }
}

enum Request {
  ///Request a device's uid.
  requestDeviceUID,

  ///Request hascodes ?
  databaseInfo,
}

enum Post {
  ///Post contains deviceUID.
  deviceUID,

  ///Post contains deviceUID and Temp Key.
  newDeviceUID,

  ///Authenticated true/false
  auth,

  ///Database info.
  databaseInfo,
}

String? requestToString(Request event) {
  switch (event) {
    case Request.requestDeviceUID:
      return 'device_uid';
    case Request.databaseInfo:
      return 'database_info';
  }
}

Request? identifyRequest(event) {
  switch (event.toString()) {
    case 'device_uid':
      return Request.requestDeviceUID;
    case 'database_info':
      return Request.databaseInfo;
  }
  return null;
}

String? postToString(Post event) {
  switch (event) {
    case Post.deviceUID:
      return 'device_uid';
    case Post.newDeviceUID:
      return 'new_device_uid';
    case Post.auth:
      return 'auth';
    case Post.databaseInfo:
      return 'database_info';
  }
}

Post? identifyPost(event) {
  switch (event.toString()) {
    case 'device_uid':
      return Post.deviceUID;
    case 'new_device_uid':
      return Post.newDeviceUID;
    case 'auth':
      return Post.auth;
    case 'database_info':
      return Post.databaseInfo;
  }
  return null;
}
