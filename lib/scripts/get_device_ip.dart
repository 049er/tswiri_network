import 'dart:io';

///Get the devices IP adress.
Future<String?> getDeviceIP() async {
  List<NetworkInterface> network = await NetworkInterface.list();

  if (network.isNotEmpty && network[0].addresses.isNotEmpty) {
    return network[0].addresses[0].address;
  }
  return null;
}
