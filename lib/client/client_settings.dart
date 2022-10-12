import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:tswiri_network/scripts/device_uid.dart';

///Server IP adress.
String? serverIP;
String serverIPPref = 'serverIP';

///Server Port.
int? serverPort;
String serverPortPref = 'serverPortPref';

///Username.
String? username;
String usernamePref = 'usernamePref';

///Device UID.
String? deviceUID;
String deviceUIDPPref = 'deviceUIDPPref';

///The unique key supplied by the server.
String? uniqueKey;
String uniqueKeyPref = 'uniqueKeyPref';

Future<void> loadAppSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  serverIP = prefs.getString(serverIPPref);
  serverPort = prefs.getInt(serverPortPref);
  username = prefs.getString(usernamePref);
  deviceUID = prefs.getString(deviceUIDPPref);
  uniqueKey = prefs.getString(uniqueKeyPref);

  log(uniqueKey.toString());

  if (deviceUID == null || (deviceUID != null && deviceUID!.isEmpty)) {
    deviceUID = generateDeviceUID();
    prefs.setString(deviceUIDPPref, deviceUID!);
  }
}

Future<void> saveServerSettings({
  required String newServerIP,
  required int newServerPort,
  required String newUniqueKey,
}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  log(newServerIP, name: 'Saving IP');
  log(newServerPort.toString(), name: 'Saving Port');
  log(newUniqueKey, name: 'Saving Key');

  prefs.setString(serverIPPref, newServerIP);
  prefs.setInt(serverPortPref, newServerPort);
  prefs.setString(uniqueKeyPref, newUniqueKey);
}

bool isReadyToConnect() {
  if (serverIP != null &&
      serverPort != null &&
      username != null &&
      deviceUID != null) {
    return true;
  }
  return false;
}
