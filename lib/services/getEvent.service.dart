import 'dart:convert';

import 'package:http/http.dart' as http;

import 'dart:io';

Future<http.Response> getBookingService(String token, String bookingId) async {
  print('getBookingService: $bookingId');
  var uri = Uri.https(
    'unlock-backend.vercel.app',
    "/bookings/me/$bookingId"
  );

  // Bypass SSL certificate verification
  HttpClient client = HttpClient();

  HttpClientRequest request = await client.getUrl(uri);
  request.headers.set('Content-Type', 'application/json');
  request.headers.set('Authorization', 'Bearer $token');

  HttpClientResponse response = await request.close();
  final responseBody = await response.transform(utf8.decoder).join();
  return http.Response(responseBody, response.statusCode);
}
