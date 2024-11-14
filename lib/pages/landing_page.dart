import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  bool _redirecting = false;
  late final StreamSubscription<AuthState> _authStateSubscription;

  @override
  void initState() {
    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) {
        if (_redirecting) return;
        final session = data.session;
        print('Session: $session');
        if (session != null) {
          _redirecting = true;
          GoRouter.of(context).go('/app');
        }
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
// Suggested code may be subject to a license. Learn more: ~LicenseLog:365545102.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3787515143.
      appBar: AppBar(
        title: const Text('Unlock'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.lock, size: 100, color: Colors.blue[900]),
            const SizedBox(height: 20),
            const Text(
              'Welcome to Unlock',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            const Text(
              'Please login to continue',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.go('/login');
              },
              child: const Text('Login'),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(150, 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
