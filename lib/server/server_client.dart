import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

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

  ///Device verified.
  bool? verified;

  ///Session authenticated.
  bool? authenticated;

  ///Device's username.
  String? username;

  ///Device's UID.
  String? deviceUID;

  ServerClient(Socket s, {required this.webSocketServer}) {
    _socket = s;
    _address = _socket.remoteAddress.address;
    _port = _socket.remotePort;

    _socket.listen(
      messageHandler,
      onError: errorHandler,
      onDone: finishedHandler,
    );
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
