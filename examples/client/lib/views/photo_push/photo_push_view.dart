import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:http_parser/http_parser.dart';

class PhotoPushView extends StatefulWidget {
  const PhotoPushView({Key? key}) : super(key: key);

  @override
  State<PhotoPushView> createState() => PhotoPushViewState();
}

class PhotoPushViewState extends State<PhotoPushView> {
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
        'photo_push_view',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      centerTitle: true,
    );
  }

  Widget _body() {
    return Center(
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              File imageFile = await getImageFileFromAssets('4.jpg');

              var request = http.MultipartRequest(
                'POST',
                Uri.parse('http://192.168.68.137:8085/upload'),
              );

              request.files.add(await http.MultipartFile.fromPath(
                  'picture', imageFile.path,
                  contentType: MediaType('image', 'jpg')));

              request.send().then((response) {
                if (response.statusCode == 200) log("Uploaded!");
              });
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}

Future<File> getImageFileFromAssets(String path) async {
  final byteData = await rootBundle.load('assets/$path');
  final buffer = byteData.buffer;
  Directory tempDir = await getTemporaryDirectory();
  String tempPath = tempDir.path;
  var filePath =
      '$tempPath/file_01.tmp'; // file_01.tmp is dump file, can be anything
  return File(filePath).writeAsBytes(
      buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
}
