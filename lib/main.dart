import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/pages/pages.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future main() async {
  // await dotenv.load();

  await Supabase.initialize(
    url: "https://vkduiueevhxmjujorjry.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZrZHVpdWVldmh4bWp1am9yanJ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM5MzUwMDgsImV4cCI6MjAzOTUxMTAwOH0.3ff9Gz8FDGLvEk6kq0q85Rky9VWl4OcPDx2nrQA7Olo",
  );
  runApp(const MyApp());
}

final GoRouter _router = GoRouter(routes: <RouteBase>[
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const LandingPage(),
      routes: <RouteBase>[
        GoRoute(path: 'login',
            builder: (BuildContext context, GoRouterState state) =>
                const LoginPage()
        ),
        GoRoute(path: 'app',
            builder: (BuildContext context, GoRouterState state) =>
                const AppPage()
        ),
        GoRoute(
          path: 'booking/:bookingId',
          builder: (BuildContext context, GoRouterState state) =>
              BookingPage(bookingId: state.pathParameters['bookingId']!),
        ),
      ]
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