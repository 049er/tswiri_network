import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:tswiri_database/export.dart';
import 'package:tswiri_network/server/shelf/router.dart';
import 'package:shelf/shelf.dart';

class ShelfManager with ChangeNotifier {
  ShelfManager({
    required this.ip,
    required this.isar,
  });

  //Ip adress.
  String ip;

  //Reference to the isar database.
  Isar isar;

  ///The shelf server.
  HttpServer? shelfServer;
  int shelfPort = 8085;
  bool shelfServerOnline = false;

  ///Server that handles photos etc.
  void startServer() async {
    Cascade cascade = Cascade().add(router()); //.add(staticHandler)

    shelfServer = await shelf_io.serve(
      logRequests().addHandler(cascade.handler),
      InternetAddress(ip), // Allows external connections
      shelfPort,
    );

    shelfServerOnline = true;
    notifyListeners();

    log('Shelf Server at http://${shelfServer!.address.host}:${shelfServer!.port}');
  }

  ///Kill the shelf sever.
  void killShelfServer() async {
    if (shelfServer != null) {
      shelfServerOnline = false;
      notifyListeners();
      await shelfServer!.close(force: true);
      shelfServer = null;
    }
  }
}
