import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:tswiri_network/commands/server_commands.dart';
import 'package:tswiri_network/server/server.dart';

///This client is used serverside.
class ServerClient {
  ///Socket.
  late Socket _socket;

  ///Adress.
  late String _address;

  ///Port.
  late int _port;

  ///Reference to the webSocketServer.
  WebSocketServer webSocketServer;

  ///Device's username.
  String? username;

  ///Device's UID.
  String? deviceUID;

  ///Device's key.
  String? key;

  ServerClient(Socket s, {required this.webSocketServer}) {
    _socket = s;
    _address = _socket.remoteAddress.address;
    _port = _socket.remotePort;

    //Add listener.
    _socket.listen(
      messageHandler,
      onError: errorHandler,
      onDone: finishedHandler,
    );

    //Request device info.
    requestDeviceInfo(_socket);
  }

  void messageHandler(Uint8List data) {
    String message = String.fromCharCodes(data).trim();
    log(message.toString());
    List command = message.split(',').toList();
    switch (command[0]) {
      case 'device_info':
        log(command.toString(), name: 'device_info');
        deviceUID = command[1];
        username = command[2];
        key = command[3];

        ///TODO:
        ///1. check if deviceUID is present in database.
        ///   check if the key matches stored key.
        ///
        ///else:
        ///
        ///2. check if sent key mathces server temporaryKey
        ///

        break;
      case 'authenticate':
        break;
      default:
        log(command.toString());
        break;
    }
  }

  void errorHandler(error) {
    log('$_address:$_port Error: $error');
    webSocketServer.removeClient(this);
    _socket.close();
  }

  void finishedHandler() {
    log('$_address:$_port Disconnected');
    webSocketServer.removeClient(this);
    _socket.close();
  }

  void write(String message) {
    _socket.write(message);
  }
}
