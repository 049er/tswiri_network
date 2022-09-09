import 'dart:convert';
import 'dart:math';

String generateTemporaryKey() {
  var random = Random.secure();
  var values = List<int>.generate(32, (i) => random.nextInt(255));
  return base64UrlEncode(values);
}
