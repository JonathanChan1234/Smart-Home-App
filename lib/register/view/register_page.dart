import 'package:auth_repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/register/bloc/register_bloc.dart';
import 'package:smart_home/register/view/register_form.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static Route<void> route() =>
      MaterialPageRoute(builder: (_) => const RegisterPage());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) {
            return RegisterBloc(
              authRepository: RepositoryProvider.of<AuthRepository>(context),
            );
          },
          child: const RegisterForm(),
        ),
      ),
    );
  }
}
