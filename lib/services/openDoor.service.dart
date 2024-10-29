import 'package:http/http.dart' as http;
import 'package:myapp/utils/utils.dart';

Future<http.Response> openDoorService(String bookingId) async {
  var uri = Uri.https(
    'unlock-rp.eastus.azurecontainer.io',
    "/bookings/use/$bookingId"
  );
  final response = await http.post(
      // Use await
      uri,
      headers: {
        "Access-Control-Allow-Origin": "*",
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

  return response;
}