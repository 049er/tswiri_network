// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';

import 'package:path_provider/path_provider.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

// Serve files from the file system.
// final staticHandler =
//     shelf_static.createStaticHandler('assets/', defaultDocument: 'index.html');

Router router() {
  Router app = Router();

  app.get('/photo', imageRequestHandler);
  app.post('/upload', imageUploadHandler);
  app.get('/test', testHandler);

  return app;
}

Response testHandler(Request request) {
  return Response.badRequest(body: 'Empty Query');
}

Response imageRequestHandler(Request request) {
  // String? token = request.headers['token'];
  // if (token == null) {
  //   return Response(400, body: 'Missing token');
  // } else {
  //   //Verify token.
  //   // if (false) {
  //   //    return Response(400, body: 'Invalid token');
  //   // } else {
  //   //
  //   // }
  // }

  // String? uid = request.headers['uid'];
  // if (uid == null) {
  //   return Response(400, body: 'Missing uid');
  // } else {
  //   //Verify UID.
  //   // if (false) {
  //   //    return Response(400, body: 'Invalid uid');
  //   // } else {
  //   //
  //   // }
  // }

  // String? user = request.headers['user'];
  // if (user == null) {
  //   return Response(400, body: 'Missing user');
  // } else {
  //   //Verify user.
  //   // if (false) {
  //   //    return Response(400, body: 'Invalid User');
  //   // } else {
  //   //
  //   // }
  // }

  Map<String, String> query = request.requestedUri.queryParameters;
  log('$query', name: 'Query');

  String? photoPath = query['image_path'];

  if (photoPath != null && photoPath.isNotEmpty) {
    List<String> validPhotos = ['1.jpg', '2.jpg', '3.jpg'];

    if (validPhotos.contains(photoPath)) {
      File file = File('assets/photos/$photoPath');
      return Response.ok(
        file.openRead(),
        headers: {
          'content-type': 'image/jpg',
        },
      );
    }
    return Response.badRequest(body: 'Photo not found');
  }
  return Response.badRequest(body: 'Empty Query');
}

Future<Response> imageUploadHandler(Request request) async {
  //Check that content-type is present.
  final contentType = request.headers['content-type'];
  if (contentType == null) {
    return Response(400, body: 'Missing content-type');
  }

  //Parse content-type.
  final mediaType = MediaType.parse(contentType);
  if (mediaType.mimeType != 'multipart/form-data') {
    return Response(400, body: 'Invalid content-type');
  }

  //Check for boundary.
  final boundary = mediaType.parameters['boundary'];
  if (boundary == null) {
    return Response(400, body: 'Missing boundary');
  }

  //Read payload.
  final payload = request.read();
  final parts = await MimeMultipartTransformer(boundary).bind(payload).toList();

  for (final part in parts) {
    if (part.headers['content-type'] != 'image/jpg') {
      continue;
    }

    final file =
        File('${(await getApplicationSupportDirectory()).path}/newImgFile.jpg');

    if (await file.exists()) {
      await file.delete();
    }
    final chunks = await part.toList();
    for (final chunk in chunks) {
      await file.writeAsBytes(chunk, mode: FileMode.append);
    }

    return Response.ok('Upload done');
  }

  return Response.badRequest();
}
