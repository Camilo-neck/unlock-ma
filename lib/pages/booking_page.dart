import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/services/services.dart';

class BookingPage extends StatefulWidget {
  final String bookingId;
  const BookingPage({super.key, required this.bookingId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final LocalAuthentication _auth = LocalAuthentication();
  String event_name = '';
  String device_name = '';
  bool _isAuthenticated = false;
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
    Future<bool> checkAuthenticated() async {
      if (!_isAuthenticated) {
        final bool canAuthenticateWithBiometrics = await _auth.canCheckBiometrics;
        if (canAuthenticateWithBiometrics) {
          try {
            final bool didAuthenticate = await _auth.authenticate(
              localizedReason: 'Please authenticate to open the door',
              options: const AuthenticationOptions(
                biometricOnly: true,
                stickyAuth: true,
                useErrorDialogs: true,
              ),
            );
            setState(() {
              _isAuthenticated = didAuthenticate;
            });
          } catch (e) {
            print('Error using biometrics: $e');
          }
        }
      }
      return _isAuthenticated;
    }

    void openDoor() async {
      // Make openDoor async
      await checkAuthenticated();
      if (!_isAuthenticated) {
        return;
      }
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
      } finally {
        setState(() {
          _isAuthenticated = false;
        });
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
