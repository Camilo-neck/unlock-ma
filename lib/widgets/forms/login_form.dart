import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/pages/landing_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isLoading = false;
  bool _redirecting = false;
  final _formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  late final StreamSubscription<AuthState> _authStateSubscription;
  bool _obscurePassword = true;

    Future<void> _signIn() async {
    try {
      setState(() {
        _isLoading = true;
      });
      await Supabase.instance.client.auth.signInWithPassword(password: passwordController.text, email: usernameController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inicio de sesión exitoso'),
          ),
        );
        usernameController.clear();
        passwordController.clear();
      }
    } on AuthException catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.message),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } catch (error) {
      if (mounted) {
      print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unexpected error occurred'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    _authStateSubscription = Supabase.instance.client.auth.onAuthStateChange.listen(
      (data) {
        if (_redirecting) return;
        final session = data.session;
        print('Session: $session');
        if (session != null) {
          _redirecting = true;
          GoRouter.of(context).go('/');
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
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ingrese su email o nickname',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: usernameController,
                    enableSuggestions: true,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email o nickname',
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ingrese su contraseña',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  TextField(
                    controller: passwordController,
                    obscureText: _obscurePassword,
                    enableSuggestions: true,
                    autocorrect: false,
                    // change height of the textfield

                    decoration: InputDecoration(
                        hintText: 'Contraseña',
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 10),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12.0)),
                        ),
                        suffix: IconButton(
                          icon: _obscurePassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                          onPressed: () {
                            // change the state of the textfield
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : () async {
                if (usernameController.text.isEmpty ||
                    passwordController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, complete todos los campos'),
                    ),
                  );
                } else {
                  print('Empiezo');
                  await _signIn();
                  print('login');
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text('Iniciar Sesión'),
            )
          ],
        ));
  }
}
