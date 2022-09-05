import 'package:client_example/settings/app_settings.dart';
import 'package:client_example/views/settings_view.dart';
import 'package:client_example/views/status_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tswiri_base/theme/theme.dart';
import 'package:tswiri_base/widgets/navigation_card.dart';
import 'package:tswiri_network/client/app_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadAppSettings();
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppClient(
        serverIP: serverIP!,
        serverPort: serverPort!,
        username: username!,
        deviceUID: deviceUID!,
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
      title: 'Sunbird Client',
      theme: sunbirdTheme,
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
          NavigationCard(
            label: 'Settings',
            icon: Icons.settings,
            viewPage: SettingsView(),
          ),
        ],
      ),
    );
  }
}
