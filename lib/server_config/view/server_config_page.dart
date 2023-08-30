import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:locale_repository/locale_repository.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:smart_home/l10n/cubit/l10n_cubit.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/server_config/bloc/server_config_bloc.dart';
import 'package:smart_home/server_config/models/models.dart';
import 'package:smart_home/widgets/custom_text_field.dart';
import 'package:smart_home_api_client/smart_home_api_client.dart';

class ServerConfigPage extends StatelessWidget {
  const ServerConfigPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => ServerConfigBloc(
          smartHomeApiClient: context.read<SmartHomeApiClient>(),
          mqttSmartHomeClient: context.read<MqttSmartHomeClient>(),
        ),
        child: const ServerConfigPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServerConfigBloc, ServerConfigState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        final successMessage =
            AppLocalizations.of(context).editServerConfigurationMessage;
        if (state.status != FormzStatus.submissionSuccess) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(successMessage),
          ),
        );
      },
      child: const ServerConfigView(),
    );
  }
}

class ServerConfigView extends StatelessWidget {
  const ServerConfigView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Center(
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
                      AppLocalizations.of(context).serverConfigurationTitle,
                      style: textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    _HttpHostInput(),
                    _HttpPortInput(),
                    _MqttHostInput(),
                    _MqttPortInput(),
                    _SameHostSwitch(),
                    _ChangeLanguageSelect(),
                    _SubmitButton(),
                    _BackButton(),
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

class _HttpHostInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerConfigBloc, ServerConfigState>(
      buildWhen: (previous, current) =>
          previous.httpHost.value != current.httpHost.value,
      builder: (context, state) {
        final localization = AppLocalizations.of(context);
        String? errorMessage;
        switch (state.httpHost.error) {
          case HttpHostValidationError.empty:
            errorMessage = localization.emptyTextFieldMessage;
            break;
          case HttpHostValidationError.invalid:
            errorMessage = localization.invalidHostName;
            break;
          case null:
            break;
        }
        return CustomTextField(
          initialValue: state.httpHost.value,
          key: const Key('serverConfigForm_httpHost_textInput'),
          onChanged: (value) => context
              .read<ServerConfigBloc>()
              .add(ServerConfigHttpHostChanged(httpHost: value)),
          errorText: errorMessage,
          labelText: localization.httpHost,
        );
      },
    );
  }
}

class _HttpPortInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerConfigBloc, ServerConfigState>(
      buildWhen: (previous, current) =>
          previous.httpPort.value != current.httpPort.value,
      builder: (context, state) {
        final localizations = AppLocalizations.of(context);
        String? errorMessage;
        switch (state.httpPort.error) {
          case HttpPortValidationError.outOfRange:
            errorMessage = localizations.invalidPortNumber;
            break;
          case null:
            break;
        }
        return CustomTextField(
          initialValue: state.httpPort.value.toString(),
          key: const Key('serverConfigForm_httpPort_textInput'),
          numberOnly: true,
          onChanged: (value) {
            try {
              context
                  .read<ServerConfigBloc>()
                  .add(ServerConfigHttpPortChanged(httpPort: int.parse(value)));
            } catch (_) {
              return;
            }
          },
          errorText: errorMessage,
          labelText: localizations.httpPort,
        );
      },
    );
  }
}

class _MqttHostInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerConfigBloc, ServerConfigState>(
      buildWhen: (previous, current) =>
          previous.mqttHost.value != current.mqttHost.value ||
          previous.sameHost != current.sameHost,
      builder: (context, state) {
        final localizations = AppLocalizations.of(context);
        String? errorMessage;
        switch (state.mqttHost.error) {
          case MqttHostValidationError.empty:
            errorMessage = localizations.emptyTextFieldMessage;
            break;
          case MqttHostValidationError.invalid:
            errorMessage = localizations.invalidHostName;
            break;
          case null:
            break;
        }
        return CustomTextField(
          initialValue: state.mqttHost.value,
          onChanged: (value) => context
              .read<ServerConfigBloc>()
              .add(ServerConfigMqttHostChanged(mqttHost: value)),
          enabled: !state.sameHost,
          labelText: localizations.mqttHost,
          errorText: errorMessage,
        );
      },
    );
  }
}

class _MqttPortInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerConfigBloc, ServerConfigState>(
      buildWhen: (previous, current) =>
          previous.mqttPort.value != current.mqttPort.value,
      builder: (context, state) {
        final localizations = AppLocalizations.of(context);
        final errorMessage =
            state.mqttPort.error == MqttPortValidationError.outOfRange
                ? localizations.invalidPortNumber
                : null;
        return CustomTextField(
          initialValue: state.mqttPort.value.toString(),
          key: const Key('serverConfigForm_mqttPort_textInput'),
          onChanged: (value) {
            try {
              context
                  .read<ServerConfigBloc>()
                  .add(ServerConfigMqttPortChanged(mqttPort: int.parse(value)));
            } catch (_) {}
          },
          errorText: errorMessage,
          labelText: localizations.mqttPort,
        );
      },
    );
  }
}

class _SameHostSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerConfigBloc, ServerConfigState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).sameHostSwitchTitle,
              style: const TextStyle(fontSize: 14),
            ),
            Switch(
              activeColor: Colors.red,
              value: state.sameHost,
              onChanged: (value) => context
                  .read<ServerConfigBloc>()
                  .add(ServerConfigSameHostToggled(sameHost: value)),
            ),
          ],
        );
      },
    );
  }
}

class _ChangeLanguageSelect extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final locale =
        context.watch<L10nCubit>().state?.languageCode ?? LanguageCode.und;
    final languages = [
      {'value': LanguageCode.english, 'label': 'English'},
      {'value': LanguageCode.chinese, 'label': '中文'},
      {
        'value': LanguageCode.und,
        'label': AppLocalizations.of(context).defaultLanguage,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context).language,
          style: const TextStyle(fontSize: 14),
        ),
        DropdownButton<String>(
          value: locale,
          icon: const Icon(Icons.keyboard_arrow_down),
          elevation: 16,
          underline: Container(
            height: 2,
            color: Colors.blue,
          ),
          onChanged: (String? value) {
            context.read<L10nCubit>().setLocale(value);
          },
          items: languages
              .map<DropdownMenuItem<String>>((Map<String, dynamic> map) {
            return DropdownMenuItem<String>(
              value: map['value'] as String,
              child: Text(
                map['label'] as String,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
        ),
      ]
          .map(
            (widget) =>
                Padding(padding: const EdgeInsets.all(4), child: widget),
          )
          .toList(),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerConfigBloc, ServerConfigState>(
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
                key: const Key('serverConfigForm_submitButton_raisedButton'),
                onPressed: state.status.isValidated
                    ? () => context
                        .read<ServerConfigBloc>()
                        .add(const ServerConfigFormSubmitted())
                    : null,
                child: Text(
                  AppLocalizations.of(context).edit,
                  style: const TextStyle(fontSize: 18),
                ),
              );
      },
    );
  }
}

class _BackButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServerConfigBloc, ServerConfigState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade500,
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.black,
            minimumSize: const Size.fromHeight(50),
          ),
          key: const Key('serverConfigForm_backButton_raisedButton'),
          onPressed: state.status.isSubmissionInProgress
              ? null
              : () => Navigator.of(context).pop(),
          child: Text(
            AppLocalizations.of(context).back,
            style: const TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }
}
