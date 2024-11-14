import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/services/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  List<dynamic> bookings = [];

  bool _redirecting = false;
  late final StreamSubscription<AuthState> _authStateSubscription;

  Future<void> _signOut() async {
    await Supabase.instance.client.auth.signOut();
  }

  Future<void> _loadBookings(String token) async {
    // Load bookings
    try {
      var response = await getBookingsService(token);

      if (response.statusCode != 200) {
        print('HTTP request failed with status: ${response.statusCode}');
        print('Response body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching bookings'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        // Handle error, maybe show a message to the user
      } else {
        setState(() {
          bookings = jsonDecode(response.body);
        });
      }
    } catch (error) {
      print('Error fetching Bookings: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching bookings'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      // Handle error, maybe show a message to the user
    }
  }

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
        await _loadBookings(session!.accessToken);
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
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: _signOut,
          ),
        ],
      ),
      body: bookings.isEmpty ? const Center(child: Text('There\'s no bookings to show')) : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(bookings[index]['event']['name']),
                  subtitle: Text(bookings[index]['device']['name']),
                  trailing: Text(bookings[index]['event']['start_time']),
                  onTap: () {
                    // Handle the tap event, maybe navigate to a detail page
                    GoRouter.of(context).go('/booking/${bookings[index]['id']}');
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}