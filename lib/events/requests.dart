import 'dart:io';
import 'dart:convert';

enum Requests {
  ///Request a device's uid.
  deviceUID,

  ///Request hascodes ?
  databaseInfo,
}

Requests identifyRequest(String request) {
  return Requests.values.byName(request);
}

class Request {
  Request(this.ws);
  WebSocket ws;

  ///Request a devicesUID.
  requestDeviceUID() {
    ws.add(json.encode(['r', Requests.deviceUID.name]));
  }

  ///Request databaseInfo
  requestDatabaseInfo() {
    ws.add(json.encode(['r', Requests.databaseInfo.name]));
  }
}
