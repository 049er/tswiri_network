import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:tswiri_network/client/client_settings.dart';
import 'package:tswiri_network/commands/client_commands.dart';
import 'package:tswiri_network/model/qr_code.dart';

class TswiriClientMobile with ChangeNotifier {
  TswiriClientMobile({
    required this.deviceUID,
    this.serverIP,
    this.serverPort,
    this.username,
    this.uniqueKey,
  });

  ///The server's IP adress.
  String? serverIP;

  ///The server's Port.
  int? serverPort;

  ///This client's username.
  String? username;

  ///This device's UID.
  String? deviceUID;

  ///Socket for communication with the server.
  Socket? socket;

  ///The unique key supplied by the sever.
  String? uniqueKey;

  ///Is trying to connect.
  bool isConnecting = false;

  Future<bool> connectToServer() async {
    isConnecting = true;
    final completer = Completer<bool>();
    log(serverIP.toString(), name: 'serverIP');
    log(serverPort.toString(), name: 'serverPort');
    log(uniqueKey.toString(), name: 'uniqueKey');

    log('attempting to connect.');
    if (socket == null &&
        serverIP != null &&
        serverPort != null &&
        uniqueKey != null) {
      log('connecting.');
      Socket.connect(serverIP, serverPort!).then((Socket sock) {
        socket = sock;
        socket!.listen(
          messageHandler,
          onError: errorHandler,
          onDone: doneHandler,
          cancelOnError: false,
        );
        return completer.complete(true);
      }).onError((error, stackTrace) {
        log('error', name: 'Socket');
        socket = null;
        return completer.complete(false);
      }).catchError((error) {
        log('error', name: 'Socket');
        socket = null;
        return completer.complete(false);
      });
      // notifyListeners();
    } else {
      completer.complete(false);
    }

    isConnecting = false;
    return completer.future;
  }

  ///Handle the message from server.
  void messageHandler(data) {
    if (socket != null) {
      String message = String.fromCharCodes(data).trim();
      List command = message.split(',').toList();
      log(command.toString(), name: 'Message: ');

      switch (command[0]) {
        case 'device_info':
          sendDeviceInfo(
            socket!,
            deviceUID: deviceUID!,
            username: username ?? '',
            key: uniqueKey,
          );
          break;
        case 'verified':
          break;
        default:
          break;
      }
    }
  }

  ///onError.
  void errorHandler(error, StackTrace trace) {
    log(error, name: 'Socket Error');
  }

  ///onDone.
  void doneHandler() {
    log('Connection closed', name: 'Done');
  }

  ///Send a message to the server.
  void sendMessage(List message) {
    socket!.write(message);
  }

  ///Connect to the server with a QRCode.
  Future<bool> connectWithQRCode(QRCodeConnect qrCodeConnect) async {
    serverIP = qrCodeConnect.ipAddress;
    serverPort = qrCodeConnect.port;
    uniqueKey = qrCodeConnect.key;

    await saveServerSettings(
      newServerIP: serverIP!,
      newServerPort: serverPort!,
      newUniqueKey: uniqueKey!,
    );

    return await connectToServer();
  }

  ///Check if the client is connected to the server,
  bool isConnected() {
    if (socket == null) {
      return false;
    }
    return true;
  }

  ///Disconect from the server.
  void disconnectFromServer() {
    if (socket != null) {
      socket!.close();
      socket = null;
    }
  }
}
