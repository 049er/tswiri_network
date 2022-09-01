import 'dart:io';

///Send the device info to sever.
void sendDeviceInfo(
  Socket socket, {
  required String deviceUID,
  required String username,
}) {
  socket.write('device_info, $deviceUID, $username');
}
