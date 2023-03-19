import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:smart_home/login/bloc/login_bloc.dart';
import 'package:smart_home/login/models/models.dart';
import 'package:smart_home/register/view/register_page.dart';
import 'package:smart_home/widgets/custom_text_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == FormzStatus.submissionFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  state.requestError == ''
                      ? 'Authentication Failure'
                      : state.requestError,
                ),
              ),
            );
        }
      },
      child: SingleChildScrollView(
        child: Align(
          alignment: const Alignment(0, -1 / 3),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Login',
                style:
                    textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Icon(
                Icons.home,
                size: 72,
              ),
              _UsernameInput(),
              const Padding(
                padding: EdgeInsets.all(12),
              ),
              _PasswordInput(),
              const Padding(
                padding: EdgeInsets.all(12),
              ),
              _LoginButton(),
              const Divider(
                height: 10,
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Do not have an account yet?',
                      style: textTheme.labelLarge!
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.account_box),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          RegisterPage.route(),
                          (route) => false,
                        );
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                      ),
                      label: const Text('Register'),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.username.value != current.username.value,
      builder: (context, state) {
        return CustomTextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(name: value)),
          errorText: state.username.error?.message,
          labelText: 'Username',
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.password.value != current.password.value,
      builder: (context, state) {
        return CustomTextField(
          key: const Key('loginForm_passwordInput_textField'),
          passwordField: true,
          onChanged: (value) => context
              .read<LoginBloc>()
              .add(LoginPasswordChanged(password: value)),
          errorText: state.password.error?.message,
          labelText: 'Password',
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.green.shade300),
                ),
                key: const Key('loginForm_loginButton_raisedButton'),
                onPressed: () => state.status.isValidated
                    ? context.read<LoginBloc>().add(const LoginFormSubmitted())
                    : null,
                child: const Text(
                  'Login',
                  style: TextStyle(color: Colors.black),
                ),
              );
      },
    );
  }
}
