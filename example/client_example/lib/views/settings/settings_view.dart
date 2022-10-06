import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tswiri_network/client/client_settings.dart';
import 'package:tswiri_network/client/tswiri_client_mobile.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
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

  Widget _body() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: const Icon(Icons.account_circle_rounded),
                title: TextFormField(
                  initialValue: username,
                  onFieldSubmitted: (value) async {
                    if (value.isNotEmpty) {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      prefs.setString(usernamePref, value);
                      username = value;

                      // ignore: use_build_context_synchronously
                      Provider.of<TswiriClientMobile>(context, listen: false)
                          .changeUsername(username!);
                    }
                  },
                ),
              ),
            ),
          )
        ],
      ),
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
}
