import 'package:flutter/material.dart';
import 'package:tswiri_database/export.dart';

class DatabaseView extends StatefulWidget {
  const DatabaseView({Key? key}) : super(key: key);

  @override
  State<DatabaseView> createState() => DatabaseViewState();
}

class DatabaseViewState extends State<DatabaseView> {
  late List<CatalogedBarcode> barcodes =
      isar!.catalogedBarcodes.where().findAllSync();

  late List<CatalogedContainer> containers =
      isar!.catalogedContainers.where().findAllSync();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              isar!.writeTxnSync((isar) => isar.clearSync());
              barcodes = isar!.catalogedBarcodes.where().findAllSync();
              containers = isar!.catalogedContainers.where().findAllSync();
              setState(() {});
            },
            child: Text(
              'Clear Database',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          _databaseCard(
            title: '1. Cataloged Containers',
            count: containers.length,
            iconData: Icons.account_box,
          ),
          _databaseCard(
            title: '2. Cataloged Barcodes',
            count: barcodes.length,
            iconData: Icons.qr_code,
          ),
        ],
      ),
    );
  }

  Widget _databaseCard({
    required String title,
    required int count,
    required IconData iconData,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(iconData),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        subtitle: Text(
          'Entries: $count',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ),
    );
  }
}
