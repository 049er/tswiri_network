import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tswiri_network_websocket/client/client_settings.dart';
import 'package:tswiri_network_websocket/communication/communication.dart';

import '../model/qr_code.dart';

class MobileClient with ChangeNotifier {
  MobileClient({
    this.ip,
    this.port,
    this.username,
    required this.deviceUID,
  });

  ///The server's IP adress.
  String? ip;

  ///Sever port.
  int? port;

  ///This client's username.
  String? username;

  ///Unique device ID.
  String deviceUID;

  ///The key provided by the server for a new device.
  String? key;

  ///The websocket
  WebSocket? ws;

  ///Communication object.
  Communication? communication;

  ///Currently connected
  bool connected = false;

  ///Send a message
  void sendMessage({
    required String identifier,
    required String message,
  }) {
    if (ws!.readyState == WebSocket.open) {
      ws!.add(json.encode(['message', 'message']));
    }
  }

  ///Disconnect from the server.
  Future<void> disconnect() async {
    if (ws != null) {
      await ws!.close();
      setDisconnect();
    }
  }

  ///Connect to the server.
  Future<void> connect() async {
    try {
      ws = await WebSocket.connect('ws://$ip:$port/ws?username=$username');

      ws!.listen(
        (event) => _handleEvent(event),
        onError: (error) => _onError(error),
        onDone: () => _onDone(),
      );

      setConntected();
    } catch (e) {
      log(e.toString(), name: 'Error');
      setDisconnect();
    }
  }

  ///Wesocket event.
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
    log(' ${data[1]}', name: 'Request');
    String request = data[1];

    switch (request) {
      case 'device_uid':
        if (key != null) {
          communication!.postNewDeviceUID(deviceUID, key!);
        } else {
          communication!.postDeviceUID(deviceUID);
        }
        break;
      default:
    }
  }

  _handlePost(List data) {
    String request = data[1];
    log(' $data', name: 'Post');
  }

  ///Websocket error.
  _onError(error) {
    log(error.toString(), name: 'Error');
  }

  ///Wesocket on done.
  _onDone() {
    log('Connection Closed', name: 'Done');
    setDisconnect();
  }

  connectWithQRCode(QRCodeConnect qrCodeConnect) async {
    disconnect();

    ip = qrCodeConnect.ipAddress;
    port = qrCodeConnect.port;
    key = qrCodeConnect.key;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(serverPortPref, port!);
    prefs.setString(serverIPPref, ip!);

    await connect();
  }

  Future<void> updateUsername(String newUsername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Update username.
    username = newUsername;
    //Update sharedprefs.
    prefs.setString(usernamePref, newUsername);

    await disconnect();
    await connect();
  }

  Future<void> updateServerPort(int newPort) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Update username.
    port = newPort;

    //Update sharedprefs.
    prefs.setInt(serverPortPref, newPort);

    await disconnect();
    await connect();
  }

  Future<void> updateServerIP(String newIP) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Update username.
    ip = newIP;

    //Update sharedprefs.
    prefs.setString(serverIPPref, newIP);

    await disconnect();
    await connect();
  }

  void setConntected() {
    connected = true;
    communication = Communication(ws: ws!);
    notifyListeners();
  }

  void setDisconnect() {
    connected = false;
    communication = null;
    notifyListeners();
  }
}
