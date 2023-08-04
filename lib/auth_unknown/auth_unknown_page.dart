import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/login/view/login_page.dart';

class AuthUnknownPage extends StatelessWidget {
  const AuthUnknownPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.warning,
              size: 108,
              color: Colors.yellow.shade900,
            ),
            Text(
              'Authentication Failed',
              style: textTheme.bodyLarge!.copyWith(fontSize: 28),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade500,
                foregroundColor: Colors.white,
                disabledForegroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => context.read<AuthRepository>().checkAuthState(),
              label: const Text(
                'Retry',
                style: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                disabledForegroundColor: Colors.black,
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => Navigator.of(context).pushAndRemoveUntil(
                LoginPage.route(),
                (_) => false,
              ),
              child: const Text('Back', style: TextStyle(fontSize: 18)),
            )
          ]
              .map(
                (widget) => Padding(
                  padding: const EdgeInsets.all(8),
                  child: widget,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
