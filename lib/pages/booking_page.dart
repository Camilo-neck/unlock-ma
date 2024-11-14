import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_auth/local_auth.dart';
import 'package:myapp/services/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
  
  bool _redirecting = false;
  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) async {
        if (_redirecting) return;
        final session = data.session;
        if (session == null) {
          _redirecting = true;
          GoRouter.of(context).go('/');
        }
        await getEvent(session!.accessToken);
      },
      onError: (error) {
        if (error is AuthException) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(error.message),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Unexpected error occurred'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      },
    );
    super.initState();
  }

  Future<void> getEvent(String token) async {
    try {
      
      var response = await getBookingService(token, widget.bookingId);
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
        String token = Supabase.instance.client.auth.currentSession!.accessToken;
        var response = await openDoorService(token, widget.bookingId);

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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            GoRouter.of(context).go('/app');
          },
        ),
      ),
      body: Center(
        child: FilledButton(
            onPressed:  openDoor, child: Text("Acceder a $device_name")),
      ),
    );
  }
}
