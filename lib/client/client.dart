import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tswiri_database/export.dart';
import 'package:tswiri_network/client/client_settings.dart';
import 'package:tswiri_network/events/events.dart';

import '../models/qr_code.dart';

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

  ///Used to send requests.
  Events? events;

  ///Currently connected
  bool connected = false;

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

  ///Handle a request.
  _handleRequest(List data) {
    Request? request = identifyRequest(data[1].toString());
    log(' $request', name: 'Request');

    switch (request) {
      case Request.requestDeviceUID:
        _handleRequestDeviceUID();
        break;
      case Request.databaseInfo:
        _handleRequestDatabaseInfo();
        break;
      default:
    }
  }

  void _handleRequestDatabaseInfo() {
    events!.postDatabaseInfo(isar!);
  }

  void _handleRequestDeviceUID() {
    if (key != null) {
      events!.postNewDeviceUID(deviceUID, key!);
    } else {
      events!.postDeviceUID(deviceUID);
    }
  }

  ///Handle a post.
  _handlePost(List data) {
    Post? post = identifyPost(data[1]);
    log(' $post', name: 'Post');
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

  ///Update the username.
  Future<void> updateUsername(String newUsername) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Update username.
    username = newUsername;
    //Update sharedprefs.
    prefs.setString(usernamePref, newUsername);

    await disconnect();
    await connect();
  }

  ///Update server port.
  Future<void> updateServerPort(int newPort) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Update username.
    port = newPort;

    //Update sharedprefs.
    prefs.setInt(serverPortPref, newPort);

    await disconnect();
    await connect();
  }

  ///Update server IP.
  Future<void> updateServerIP(String newIP) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Update username.
    ip = newIP;

    //Update sharedprefs.
    prefs.setString(serverIPPref, newIP);

    await disconnect();
    await connect();
  }

  ///Connect with a qr-code.
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

  void setConntected() {
    connected = true;
    events = Events(ws: ws!);
    notifyListeners();
  }

  void setDisconnect() {
    connected = false;
    events = null;
    notifyListeners();
  }
}
