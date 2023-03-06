import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/login/bloc/login_bloc.dart';
import 'package:smart_home/login/view/login_form.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const LoginPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) {
            return LoginBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            );
          },
          child: const LoginForm(),
        ),
      ),
    );
  }
}
