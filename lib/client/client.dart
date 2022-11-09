// import 'dart:convert';
// import 'dart:developer';
// import 'dart:io';

// import 'package:flutter/cupertino.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tswiri_network/client/client_shared_prefs.dart';
// import 'package:tswiri_network/events/posts.dart';
// import 'package:tswiri_network/events/requests.dart';
// import 'package:tswiri_network/scripts/generate_device_uid.dart';

// class Client with ChangeNotifier {
//   Client() {
//     _init();
//   }
//   //Server's ip.
//   String? serverIP;

//   //Server's port.
//   int? serverPort;

//   //Device's username.
//   String? username;

//   //Device's UID.
//   String? deviceUID;

//   ///The websocket
//   WebSocket? ws;

//   ///Initiate the server client.
//   _init() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();

//     serverIP = prefs.getString(serverIPPref);
//     serverPort = prefs.getInt(serverPortPref);
//     username = prefs.getString(usernamePref);
//     deviceUID = prefs.getString(deviceUIDPPref);

//     if (deviceUID == null || (deviceUID != null && deviceUID!.isEmpty)) {
//       deviceUID = generateDeviceUID();
//       prefs.setString(deviceUIDPPref, deviceUID!);
//     }

//     log('IP: $serverIP\nPort: $serverPort\nUSR: $username\nUID: $deviceUID');

//     connectToServer();
//   }

//   disconnectFromServer() {
//     if (ws == null) return;
//     ws!.close();
//     ws = null;
//     notifyListeners();
//   }

//   connectToServer() async {
//     if (ws != null) return;
//     if (serverIP != null && serverPort != null) {
//       try {
//         ws = await WebSocket.connect('ws://$serverIP:$serverPort/ws');

//         ws!.listen(
//           (event) => _onEvent(event),
//           onError: (error) => _onError(error),
//           onDone: _onDone,
//         );
//       } catch (e) {
//         log(e.toString(), name: 'Error');
//       }
//     }
//     notifyListeners();
//   }

//   _onEvent(event) {
//     List data = List.from(json.decode(event));
//     String identifier = data[0];
//     switch (identifier) {
//       case 'r':
//         _handleRequest(data);
//         break;
//       case 'p':
//         _handlePost(data);
//         break;
//       default:
//     }
//   }

//   _handleRequest(List r) {
//     log(r.toString(), name: 'request');
//     Requests request = Requests.values.byName(r[1]);
//     switch (request) {
//       case Requests.deviceUID:
//         Post(ws!).postDeviceUID(deviceUID!);
//         break;
//       case Requests.databaseInfo:
//         // Post(ws!).postDatabaseInfo();
//         break;
//       default:
//     }
//   }

//   _handlePost(List p) {
//     log(p.toString(), name: 'post');
//   }

//   _onError(error) {
//     log(error, name: 'Error');
//   }

//   _onDone() {
//     ws = null;
//     notifyListeners();
//   }

//   ///Update serverIP
//   updateIP(String newIP) async {
//     serverIP = newIP;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString(serverIPPref, newIP);
//   }

//   ///Update serverIP
//   updatePort(int newPort) async {
//     serverPort = newPort;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setInt(serverPortPref, newPort);
//   }

//   updateUsername(String newUsername) async {
//     username = newUsername;
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     prefs.setString(usernamePref, newUsername);
//   }
// }
