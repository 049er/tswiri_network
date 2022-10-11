import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:server/views/devices/devices_view.dart';
import 'package:server/views/qr_code/qr_code_view.dart';
import 'package:server/views/settings/settings_view.dart';
import 'package:tswiri_network_websocket/scripts/get_device_ip.dart';
import 'package:tswiri_network_websocket/server/shelf_server.dart';
import 'package:tswiri_network_websocket/server/websocket_server.dart';
import 'package:tswiri_widgets/theme/theme.dart';

void main() async {
  String? ip = await getDeviceIP();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => WsManager(ip: ip ?? '')),
        ChangeNotifierProvider(create: (context) => ShelfManager(ip: ip ?? '')),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Server',
      theme: tswiriTheme,
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
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

  List<Widget> views = [
    const DevicesView(),
    const QrCodeView(),
    const SettingsView()
  ];

  @override
  void initState() {
    super.initState();
    Provider.of<WsManager>(context, listen: false).startServer();
    Provider.of<ShelfManager>(context, listen: false).startServer();
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
          labelType: NavigationRailLabelType.all,
          destinations: const <NavigationRailDestination>[
            NavigationRailDestination(
              icon: Icon(Icons.device_hub_sharp),
              selectedIcon: Icon(Icons.device_hub_sharp),
              label: Text('Devices'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.qr_code),
              selectedIcon: Icon(Icons.qr_code),
              label: Text('QR Code'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.qr_code),
              selectedIcon: Icon(Icons.settings),
              label: Text('Settings'),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        views[_selectedIndex],
      ],
    );
  }
}
