// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:io';

import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:shelf/shelf.dart';

Future<Response> testHandler(Request request) async {
  log('response');
  final file = File('images/test.jpg');
  file.createSync();
  return Response.badRequest();
}

Future<Response> imageReceiveHandler(Request request) async {
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

    final file = File('photos/test.jpg');

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
