import 'package:flutter/material.dart';
import 'package:tswiri_database/export.dart';

class SendContainerView extends StatefulWidget {
  const SendContainerView({Key? key}) : super(key: key);

  @override
  State<SendContainerView> createState() => SendContainerViewState();
}

class SendContainerViewState extends State<SendContainerView> {
  bool sendingData = false;

  late CatalogedContainer catalogedContainer =
      isar!.catalogedContainers.where().findAllSync()[0];

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
        'send_container_view',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        children: [
          _sendMe(),
          _dataCard(),
        ],
      ),
    );
  }

  Widget _sendMe() {
    return Card(
      child: ListTile(
        title: Text(
          'Send Message',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        trailing: sendingData
            ? const CircularProgressIndicator()
            : IconButton(
                onPressed: () async {
                  setState(() {
                    sendingData = true;
                  });

                  await Future.delayed(const Duration(milliseconds: 250));

                  setState(() {
                    sendingData = false;
                  });
                },
                icon: const Icon(Icons.send),
              ),
      ),
    );
  }

  Widget _dataCard() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.data_array),
        title: Text(
          'Container',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ID: ${catalogedContainer.id}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'UID: ${catalogedContainer.containerUID}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Name: ${catalogedContainer.name ?? '-'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Barcode: ${catalogedContainer.barcodeUID ?? '-'}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
