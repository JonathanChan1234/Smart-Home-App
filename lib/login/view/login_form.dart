import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/login/bloc/login_bloc.dart';
import 'package:smart_home/login/models/models.dart';
import 'package:smart_home/register/view/register_page.dart';
import 'package:smart_home/server_config/view/server_config_page.dart';
import 'package:smart_home/widgets/custom_text_field.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context);
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
      child: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppLocalizations.of(context).loginTitle,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    _UsernameInput(),
                    _PasswordInput(),
                    _LoginButton(),
                    const Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    Text(
                      localization.dontHaveAccountText,
                      style: textTheme.labelLarge!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.account_box),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          RegisterPage.route(),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade500,
                        foregroundColor: Colors.white,
                        disabledForegroundColor: Colors.black,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      label: Text(
                        AppLocalizations.of(context).registerTitle,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    _ToServerConfigButton(),
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
            ),
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
        String? errorMessage;
        final localization = AppLocalizations.of(context);
        switch (state.username.error) {
          case UsernameValidationError.empty:
            errorMessage = localization.emptyUsernameMessage;
            break;
          case UsernameValidationError.tooLong:
            errorMessage = localization.tooLongUsernameMessage;
            break;
          case null:
            errorMessage = null;
            break;
        }
        return CustomTextField(
          key: const Key('loginForm_usernameInput_textField'),
          onChanged: (value) =>
              context.read<LoginBloc>().add(LoginUsernameChanged(name: value)),
          errorText: errorMessage,
          labelText: AppLocalizations.of(context).username,
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
        String? errorMessage;
        final localization = AppLocalizations.of(context);
        switch (state.password.error) {
          case PasswordValidationError.empty:
            errorMessage = localization.emptyPasswordMessage;
            break;
          case PasswordValidationError.invalid:
            errorMessage = localization.invalidPasswordMessage;
            break;
          case null:
            errorMessage = null;
            break;
        }
        return CustomTextField(
          key: const Key('loginForm_passwordInput_textField'),
          passwordField: true,
          onChanged: (value) => context
              .read<LoginBloc>()
              .add(LoginPasswordChanged(password: value)),
          errorText: errorMessage,
          labelText: AppLocalizations.of(context).password,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                ),
                key: const Key('loginForm_loginButton_raisedButton'),
                onPressed: state.status.isValidated
                    ? () => context
                        .read<LoginBloc>()
                        .add(const LoginFormSubmitted())
                    : null,
                child: Text(
                  AppLocalizations.of(context).loginTitle,
                  style: const TextStyle(fontSize: 18),
                ),
              );
      },
    );
  }
}

class _ToServerConfigButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton.icon(
          icon: const Icon(Icons.dns),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.black,
            minimumSize: const Size.fromHeight(50),
          ),
          key: const Key('loginForm_serverConfig_raisedButton'),
          onPressed: state.status.isSubmissionInProgress
              ? null
              : () => Navigator.of(context).push(ServerConfigPage.route()),
          label: Text(
            AppLocalizations.of(context).editServerConfiguration,
            style: const TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }
}
