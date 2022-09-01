import 'dart:io';

///Request device info.
void requestDeviceInfo(Socket client) {
  client.write('device_info');
}
