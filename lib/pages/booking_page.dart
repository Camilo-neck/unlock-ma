import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:myapp/services/services.dart';

class BookingPage extends StatefulWidget {
  final String bookingId;
  const BookingPage({super.key, required this.bookingId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String event_name = '';
  String device_name = '';
  @override
  void initState() {
    super.initState();
    getEvent();
  }

  Future<void> getEvent() async {
    try {
      var response = await getBookingService(widget.bookingId);

      if (response.statusCode != 200) {
        print('HTTP request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        // Handle error, maybe show a message to the user
      } else {
        // Request successful
        print('Info Retrieved');
        setState(() {
          event_name = jsonDecode(response.body)['event']['name'];
        });
        setState(() {
          device_name = jsonDecode(response.body)['device']['name'];
        });
      }
    } catch (error) {
      print('Error fetching Booking: $error');
      // Handle error, maybe show a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    void openDoor() async {
      // Make openDoor async
      try {
        var response = await openDoorService(widget.bookingId);

        if (response.statusCode != 200) {
          print('HTTP request failed with status: ${response.statusCode}');
          print('Response body: ${response.body}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Error al abrir la puerta: ${jsonDecode(response.body)['detail']}'),
            ),
          );
          // Handle error, maybe show a message to the user
        } else {
          // Request successful
          print('Door opened successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Puerta abierta con éxito'),
            ),
          );
        }
      } catch (error) {
        print('Error opening door: $error');
        // Handle error, maybe show a message to the user
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(event_name),
      ),
      body: Center(
        child: FilledButton(
            onPressed: openDoor, child: Text("Acceder a $device_name")),
      ),
    );
  }
}
