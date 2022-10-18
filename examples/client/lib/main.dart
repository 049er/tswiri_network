import 'package:camera/camera.dart';
import 'package:client/views/photo_push/photo_push_view.dart';
import 'package:client/views/photo_view/photo_view.dart';
import 'package:client/views/send_container/send_container_view.dart';
import 'package:client/views/settings/settigns_view.dart';
import 'package:client/views/status/status_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tswiri_database/export.dart';
import 'package:tswiri_database/functions/isar/create_functions.dart';
import 'package:tswiri_database/functions/isar/isar_functions.dart';
import 'package:tswiri_database/mobile_database.dart';
import 'package:tswiri_database/export.dart';
import 'package:tswiri_database/functions/isar/create_functions.dart';
import 'package:tswiri_database/mobile_database.dart';
import 'package:tswiri_database/models/settings/app_settings.dart';
import 'package:tswiri_database/test_functions/populate_database.dart';
import 'package:tswiri_network/client/client.dart';
import 'package:tswiri_widgets/theme/theme.dart';
import 'package:tswiri_network/client/client_settings.dart';
import 'package:tswiri_widgets/widgets/general/navigation_card.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await loadAppNetworkSettings();

  //Force portraitUp.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  //Load app settings.
  await loadAppNetworkSettings();

  //Initiate Isar Storage Directories.
  await initiateSpaceDirectory();
  await initiatePhotoStorage();
  await initiateThumnailStorage();

  //Initiate Isar.
  isar = initiateMobileIsar();
  createBasicContainerTypes();

  //Initiate Isar Storage Directories.
  await initiateSpaceDirectory();
  await initiatePhotoStorage();

  //Initiate Isar.
  isar = initiateMobileIsar();
  createBasicContainerTypes();

  //Test population :L
  populateDatabase();

  //Force portraitUp.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    ChangeNotifierProvider(
      create: (context) => MobileClient(
        ip: serverIP, //'192.168.68.137'
        port: serverPort, //8080
        username: '049er',
        deviceUID: deviceUID!,
      ),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Client',
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
  @override
  void initState() {
    super.initState();
    // Provider.of<MobileClient>(context, listen: false).connect();
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
        'main',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
      leading: Icon(
        Provider.of<MobileClient>(context).connected
            ? Icons.check
            : Icons.priority_high,
      ),
      actions: [
        PopupMenuButton(
          onSelected: (value) {
            switch (value) {
              case 'settings_view':
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const SettignsView(),
                  ),
                );
                break;
              case 'status_view':
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const StatusView(),
                  ),
                );
                break;
              default:
            }
          },
          itemBuilder: ((context) => [
                PopupMenuItem(
                  value: 'settings_view',
                  child: Text(
                    'Settings',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                PopupMenuItem(
                  value: 'status_view',
                  child: Text(
                    'Status',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ]),
        ),
      ],
    );
  }

  Widget _body() {
    return Center(
      child: GridView.count(
        padding:
            const EdgeInsets.only(top: 8.0, bottom: 100, left: 8, right: 8),
        crossAxisCount: 2,
        children: const [
          NavigationCard(
            label: 'Photo View',
            icon: Icons.photo,
            viewPage: PhotoView(),
          ),
          NavigationCard(
            label: 'Photos Push',
            icon: Icons.photo,
            viewPage: PhotoPushView(),
          ),
          NavigationCard(
            label: 'Send Data',
            icon: Icons.data_array,
            viewPage: SendContainerView(),
          ),
        ],
      ),
    );
  }
}
