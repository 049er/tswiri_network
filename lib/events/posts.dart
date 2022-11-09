import 'dart:convert';
import 'dart:developer';
import 'dart:io';

// import 'package:tswiri_database/models/sync/database_sync.dart';

enum Posts {
  ///Post contains deviceUID.
  deviceUID,

  ///Post contains deviceUID and Temp Key.
  newDeviceUID,

  ///Authenticated true/false
  auth,

  ///Database info.
  databaseInfo,
}

Posts identifyPost(String post) {
  return Posts.values.byName(post);
}

class Post {
  Post(this.ws);
  WebSocket ws;

  ///Send a device's UID.
  postDeviceUID(String deviceUID) {
    ws.add(json.encode(['p', Posts.deviceUID.name, deviceUID]));
  }

  ///Send database info.
  postDatabaseInfo() {
    // ws.add(json.encode(['p', Posts.databaseInfo, DatabaseSync().jsonHash()]));
  }
}
