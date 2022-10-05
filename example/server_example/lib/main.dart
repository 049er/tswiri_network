import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server_example/views/connect/connect_view.dart';
import 'package:server_example/views/devices/devices_view.dart';
import 'package:tswiri_network/server/server.dart';
import 'package:tswiri_widgets/theme/theme.dart';

WebSocketServer? webSocketServer;
void main() async {
  ServerSocket serverSocket = await startServer(
    ip: '192.168.1.111',
    port: 8080,
  );

  runApp(
    ChangeNotifierProvider(
      create: (context) => WebSocketServer(serverSocket: serverSocket),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tswiri Server',
      theme: tswiriTheme,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  List<Widget> views = [
    const DevicesView(),
    const ConnectView(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: _selectedIndex,
          groupAlignment: -1,
          onDestinationSelected: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          labelType: labelType,
          destinations: const <NavigationRailDestination>[
            NavigationRailDestination(
              icon: Icon(Icons.device_hub_sharp),
              selectedIcon: Icon(Icons.device_hub_sharp),
              label: Text('Devices'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.qr_code),
              selectedIcon: Icon(Icons.qr_code),
              label: Text('Connect'),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        views[_selectedIndex],
      ],
    );
  }
}
