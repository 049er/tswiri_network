import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:tswiri_network/server/shelf_server/router.dart';

class ShelfServer {
  ShelfServer({
    required this.ip,
    required this.port,
  }) {
    _init();
  }
  //IP address.
  String ip;

  //Port
  int port;

  _init() async {
    final cascade = Cascade().add(router());

    final server = await serve(
      logRequests().addHandler(cascade.handler),
      InternetAddress(ip),
      port,
      shared: true,
    );

    print('Serving at http://${server.address.host}:${server.port}');
  }
}
