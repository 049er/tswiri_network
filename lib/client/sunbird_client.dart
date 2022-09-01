import 'dart:developer';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:tswiri_network/commands/client_commands.dart';

///This client is used on device.
class SunbirdClient with ChangeNotifier {
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

  ///Is this device verified on the sever's side.
  bool? verified;

  ///Has this session been authenticated.
  bool? authenticated;

  SunbirdClient({
    required this.serverIP,
    required this.serverPort,
    required this.username,
    required this.deviceUID,
  }) {
    connectToServer();
    // stdnListener();
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
            username: username!,
          );
          break;
        case 'verified':
          verified = command[1] == 'true' ? true : false;
          break;
        default:
          log(command.toString());
          break;
      }
    }
  }

  void errorHandler(error, StackTrace trace) {
    log(error, name: 'Socket Error');
  }

  void doneHandler() {
    socket!.destroy();
    exit(0);
  }

  void sendMessage(List message) {
    socket!.write(message);
  }

  void connectToServer() {
    if (socket == null && serverIP != null && serverPort != null) {
      Socket.connect(serverIP, serverPort!).then((Socket sock) {
        socket = sock;
        socket!.listen(
          messageHandler,
          onError: errorHandler,
          onDone: doneHandler,
          cancelOnError: false,
        );
      }).onError((error, stackTrace) {
        log('error');
        socket = null;
      }).catchError((error) {
        log('error');
        socket = null;
      });
      // stdnListener();
      notifyListeners();
    }
  }

  void setServerIP(String ip) {
    if (socket == null) {
      serverIP = ip;
    } else {
      socket!.close();
      socket = null;
    }
  }

  void setServerPort(int port) {
    if (socket == null) {
      serverPort = port;
    } else {
      socket!.close();
      socket = null;
    }
  }

  void setUsername(String usr) {
    if (socket == null) {
      username = usr;
    } else {
      socket!.close();
      socket = null;
    }
  }
}


  // void stdnListener() {
  //   // if (socket != null) {
  //   //   stdin.listen(
  //   //       (data) => socket!.write('${String.fromCharCodes(data).trim()}\n'));
  //   // }
  // }