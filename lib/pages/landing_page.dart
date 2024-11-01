import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:365545102.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:3787515143.
      appBar: AppBar(
        title: const Text('Unlock'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.go('/booking/21a3a049-a2a7-4d17-a4e2-2338358b6fac');
        },
        tooltip: 'Go to Booking',
        child: const Icon(Icons.add),
      ),
    );
  }
}
