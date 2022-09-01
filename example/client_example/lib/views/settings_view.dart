import 'package:client_example/main.dart';
import 'package:client_example/settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sunbird_base/widgets/custom_text_field.dart';
import 'package:sunbird_network/client/sunbird_client.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
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
        'Settings',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
    );
  }

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.devices),
              title: Text(
                deviceUID.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ),
          Card(
            child: CustomTextField(
              label: 'Username',
              initialValue: username,
              maxLines: 1,
              onSubmitted: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                username = value;
                prefs.setString(usernamePref, value);
                if (mounted) {
                  Provider.of<SunbirdClient>(context, listen: false)
                      .setUsername(username!);
                }

                setState(() {});
              },
            ),
          ),
          Card(
            child: CustomTextField(
              label: 'Server IP',
              initialValue: serverIP,
              maxLines: 1,
              onSubmitted: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                serverIP = value;
                prefs.setString(serverIPPref, value);
                if (mounted) {
                  Provider.of<SunbirdClient>(context, listen: false)
                      .setServerIP(serverIP!);
                }
                setState(() {});
              },
            ),
          ),
          Card(
            child: CustomTextField(
              label: 'Server Port',
              initialValue: serverPort.toString(),
              textInputType: TextInputType.number,
              maxLines: 1,
              onSubmitted: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                serverPort = int.tryParse(value) ?? serverPort;
                if (serverPort != null) {
                  prefs.setInt(serverPortPref, serverPort!);

                  if (mounted) {
                    Provider.of<SunbirdClient>(context, listen: false)
                        .setServerPort(serverPort!);
                  }
                }
                setState(() {});
              },
            ),
          ),
        ],
      ),
    );
  }
}
