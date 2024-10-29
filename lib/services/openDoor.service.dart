import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/utils/utils.dart';

Future<http.Response> openDoorService(String bookingId) async {
  var uri = Uri.https(
    'unlock-rp.eastus.azurecontainer.io',
    "/bookings/use/$bookingId"
  );

  HttpClient client = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

  HttpClientRequest request = await client.postUrl(uri);
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Authorization', 'Bearer $token');

  HttpClientResponse response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  return http.Response(responseBody, response.statusCode);
}