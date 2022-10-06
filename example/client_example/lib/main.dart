import 'package:camera/camera.dart';
import 'package:client_example/views/settings/settings_view.dart';
import 'package:client_example/views/status/status_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tswiri_network/client/client_settings.dart';
import 'package:tswiri_network/client/tswiri_client_mobile.dart';
import 'package:tswiri_widgets/theme/theme.dart';
import 'package:tswiri_widgets/widgets/general/navigation_card.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await loadAppSettings();

  runApp(
    ChangeNotifierProvider(
      create: (context) => TswiriClientMobile(
        deviceUID: deviceUID,
        serverIP: serverIP,
        serverPort: serverPort,
        username: username,
        uniqueKey: uniqueKey,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tswiri Client',
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<TswiriClientMobile>(context).connectToServer();
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'Client',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsView()));
          },
          icon: const Icon(Icons.settings),
        ),
      ],
    );
  }

  Widget _body() {
    return Center(
      child: GridView.count(
        crossAxisCount: 2,
        children: const [
          NavigationCard(
            label: 'Status',
            icon: Icons.stacked_line_chart_sharp,
            viewPage: StatusView(),
          ),
          // NavigationCard(
          //   label: 'Settings',
          //   icon: Icons.settings,
          //   viewPage: SettingsView(),
          // ),
        ],
      ),
    );
  }
}
