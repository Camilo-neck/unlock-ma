import 'dart:io';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:myapp/utils/utils.dart';

Future<http.Response> openDoorService(String token, String bookingId) async {
  var uri = Uri.https(
    'unlock-backend.vercel.app',
    "/bookings/use/$bookingId"
  );

  HttpClient client = HttpClient();

  HttpClientRequest request = await client.postUrl(uri);
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Authorization', 'Bearer $token');

  HttpClientResponse response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  return http.Response(responseBody, response.statusCode);
}