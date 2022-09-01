import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunbird_network/client/device_uid.dart';

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

Future<void> loadAppSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  serverIP = prefs.getString(serverIPPref);
  serverPort = prefs.getInt(serverPortPref);
  username = prefs.getString(usernamePref);
  deviceUID = prefs.getString(deviceUIDPPref);

  if (deviceUID == null || (deviceUID != null && deviceUID!.isEmpty)) {
    deviceUID = generateDeviceUID();
    prefs.setString(deviceUIDPPref, deviceUID!);
  }
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
