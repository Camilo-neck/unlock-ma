import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/pages/pages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future main() async {
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );
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
  GoRoute(path: '/app',
      builder: (BuildContext context, GoRouterState state) =>
          const AppPage()
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