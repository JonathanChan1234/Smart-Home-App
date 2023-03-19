import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:smart_home/login/view/login_page.dart';
import 'package:smart_home/register/bloc/register_bloc.dart';
import 'package:smart_home/register/models/models.dart';
import 'package:smart_home/widgets/custom_text_field.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return BlocListener<RegisterBloc, RegisterState>(
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
                'Register',
                style:
                    textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Icon(
                Icons.home,
                size: 72,
              ),
              _EmailInput(),
              const Padding(
                padding: EdgeInsets.all(12),
              ),
              _UsernameInput(),
              const Padding(
                padding: EdgeInsets.all(12),
              ),
              _PasswordInput(),
              const Padding(
                padding: EdgeInsets.all(12),
              ),
              _ConfirmPasswordInput(),
              const Padding(
                padding: EdgeInsets.all(12),
              ),
              _RegisterButton(),
              const Divider(
                height: 10,
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Already have an account yet?',
                      style: textTheme.labelLarge!
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.account_box),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          LoginPage.route(),
                          (route) => false,
                        );
                      },
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.red),
                      ),
                      label: const Text('Click here to login'),
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

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.username.value != current.username.value,
      builder: (context, state) {
        final error = state.email.error;
        return CustomTextField(
          key: const Key('register_email_textField'),
          onChanged: (value) => context
              .read<RegisterBloc>()
              .add(RegisterEmailChanged(email: value)),
          errorText: state.email.invalid ? error?.message : null,
          labelText: 'Email',
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.username.value != current.username.value,
      builder: (context, state) {
        final error = state.username.error;
        return CustomTextField(
          key: const Key('register_usernameInput_textField'),
          onChanged: (value) => context
              .read<RegisterBloc>()
              .add(RegisterUsernameChanged(username: value)),
          errorText: state.username.invalid ? error?.message : null,
          labelText: 'Username',
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.password.value != current.password.value,
      builder: (context, state) {
        final error = state.password.error;
        return CustomTextField(
          key: const Key('register_passwordInput_textField'),
          onChanged: (value) => context
              .read<RegisterBloc>()
              .add(RegisterPasswordChanged(password: value)),
          errorText: state.password.invalid ? error?.message : null,
          labelText: 'Password',
          passwordField: true,
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.password.value != current.password.value,
      builder: (context, state) {
        final error = state.confirmPassword.error;
        return CustomTextField(
          key: const Key('register_confirmPasswordInput_textField'),
          onChanged: (value) => context
              .read<RegisterBloc>()
              .add(RegisterConfirmPasswordChanged(confirmPassword: value)),
          errorText: state.confirmPassword.invalid ? error?.message : null,
          labelText: 'Confirm Password',
          passwordField: true,
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return state.status.isSubmissionInProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Colors.green.shade300),
                ),
                key: const Key('registerForm_registerButton_raisedButton'),
                onPressed: () => state.status.isValidated
                    ? context
                        .read<RegisterBloc>()
                        .add(const RegisterFormSubmitted())
                    : null,
                child: const Text(
                  'Register',
                  style: TextStyle(color: Colors.black),
                ),
              );
      },
    );
  }
}
