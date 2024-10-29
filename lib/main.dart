import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/pages/pages.dart';

Future main() async {
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const LandingPage()),
  GoRoute(path: '/login',
      builder: (BuildContext context, GoRouterState state) =>
          const LoginPage()
  ),
  GoRoute(
    path: '/booking/:bookingId',
    builder: (BuildContext context, GoRouterState state) =>
        BookingPage(bookingId: state.pathParameters['bookingId']!),
  ),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}