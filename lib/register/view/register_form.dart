import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/login/view/login_page.dart';
import 'package:smart_home/register/bloc/register_bloc.dart';
import 'package:smart_home/register/models/models.dart';
import 'package:smart_home/server_config/view/server_config_page.dart';
import 'package:smart_home/widgets/custom_text_field.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final localization = AppLocalizations.of(context);
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
                      localization.registerTitle,
                      style: textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    _EmailInput(),
                    _UsernameInput(),
                    _PasswordInput(),
                    _ConfirmPasswordInput(),
                    _RegisterButton(),
                    const Divider(
                      height: 20,
                      thickness: 2,
                    ),
                    Text(
                      localization.alreadyHaveAccountMessage,
                      style: textTheme.labelLarge!
                          .copyWith(fontSize: 16, fontWeight: FontWeight.w700),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.account_box),
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          LoginPage.route(),
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
                        localization.clickHereToLoginMessage,
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

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);

    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.username.value != current.username.value,
      builder: (context, state) {
        String? errorMessage;
        switch (state.email.error) {
          case EmailValidationError.empty:
            errorMessage = localization.emptyEmailMessage;
            break;
          case EmailValidationError.invalid:
            errorMessage = localization.invalidEmailMesssage;
            break;
          case null:
            break;
        }
        return CustomTextField(
          key: const Key('register_email_textField'),
          onChanged: (value) => context
              .read<RegisterBloc>()
              .add(RegisterEmailChanged(email: value)),
          errorText: errorMessage,
          labelText: localization.email,
        );
      },
    );
  }
}

class _UsernameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.username.value != current.username.value,
      builder: (context, state) {
        String? errorMessage;
        switch (state.username.error) {
          case UsernameValidationError.empty:
            errorMessage = localization.emptyUsernameMessage;
            break;
          case UsernameValidationError.tooLong:
            errorMessage = localization.tooLongUsernameMessage;
            break;
          case null:
            break;
        }
        return CustomTextField(
          key: const Key('register_usernameInput_textField'),
          onChanged: (value) => context
              .read<RegisterBloc>()
              .add(RegisterUsernameChanged(username: value)),
          errorText: errorMessage,
          labelText: localization.username,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.password.value != current.password.value,
      builder: (context, state) {
        String? errorMessage;
        switch (state.password.error) {
          case PasswordValidationError.empty:
            errorMessage = localization.emptyPasswordMessage;
            break;
          case PasswordValidationError.invalid:
            errorMessage = localization.invalidPasswordMessage;
            break;
          case null:
            break;
        }
        return CustomTextField(
          key: const Key('register_passwordInput_textField'),
          onChanged: (value) => context
              .read<RegisterBloc>()
              .add(RegisterPasswordChanged(password: value)),
          errorText: errorMessage,
          labelText: localization.password,
          passwordField: true,
        );
      },
    );
  }
}

class _ConfirmPasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.password.value != current.password.value ||
          previous.confirmPassword.value != current.confirmPassword.value,
      builder: (context, state) {
        String? errorMessage;
        switch (state.confirmPassword.error) {
          case ConfirmPasswordValidationError.empty:
            errorMessage = localization.emptyPasswordMessage;
            break;
          case ConfirmPasswordValidationError.invalid:
            errorMessage = localization.invalidPasswordMessage;
            break;
          case ConfirmPasswordValidationError.mismatch:
            errorMessage = localization.notMatchConfirmPassword;
            break;
          case null:
            break;
        }
        return CustomTextField(
          key: const Key('register_confirmPasswordInput_textField'),
          onChanged: (value) => context
              .read<RegisterBloc>()
              .add(RegisterConfirmPasswordChanged(confirmPassword: value)),
          errorText: errorMessage,
          labelText: localization.confirmPasword,
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade500,
                  foregroundColor: Colors.white,
                  disabledForegroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                ),
                key: const Key('registerForm_registerButton_raisedButton'),
                onPressed: state.status.isValidated
                    ? () => context
                        .read<RegisterBloc>()
                        .add(const RegisterFormSubmitted())
                    : null,
                child: Text(
                  AppLocalizations.of(context).registerTitle,
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
    return BlocBuilder<RegisterBloc, RegisterState>(
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
          key: const Key('registerForm_serverConfig_raisedButton'),
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
