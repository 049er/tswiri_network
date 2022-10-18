import 'dart:convert';
import 'dart:developer';
import 'dart:io';

///Add any websocket communication here.
class Communication {
  Communication({
    required this.ws,
  });
  //Webscoket.
  WebSocket ws;

  ///Request a devices UID. (server)
  requestDeviceUID() {
    log('device_uid', name: 'Send Request');
    ws.add(json.encode(['request', 'device_uid']));
  }

  ///Send device uid. (client)
  postDeviceUID(String uid) {
    log('device_uid= $uid', name: 'Send Post');
    ws.add(json.encode(['post', 'device_uid', uid]));
  }

  ///Send a device UID along with the temporary key. (client)
  postNewDeviceUID(String uid, String tempKey) {
    log('device_uid= $uid : tempKey= $tempKey', name: 'Send Post');
    ws.add(json.encode(['post', 'new_device_uid', uid, tempKey]));
  }

  ///Send a valid authentication notice. (server)
  postValidAuthentication() {
    log('Authenticated :D', name: 'Send Post');
    ws.add(json.encode(['post', 'auth', 'true']));
  }

  ///Send a invalid authentication notice. (server)
  postInvalidAuthentication() {
    log('Authenticated D;', name: 'Send Post');
    ws.add(json.encode(['post', 'auth', 'false']));
  }

  ///Send a container to server. (client)
  postContainer(String data) {
    log('Authenticated D;', name: 'Send Post');
    ws.add(json.encode(['post', 'container', data]));
  }
}
