import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
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
        if (state.status != FormzStatus.submissionSuccess) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Edit server configuration successfully'),
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
                      'Server Configuration',
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
        final error = state.httpHost.error;
        return CustomTextField(
          initialValue: state.httpHost.value,
          key: const Key('serverConfigForm_httpHost_textInput'),
          onChanged: (value) => context
              .read<ServerConfigBloc>()
              .add(ServerConfigHttpHostChanged(httpHost: value)),
          errorText: state.httpHost.invalid ? error?.message : null,
          labelText: 'HTTP Host',
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
        final error = state.httpPort.error;
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
          errorText: state.httpPort.invalid ? error?.message : null,
          labelText: 'HTTP Port',
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
        final error = state.mqttHost.error;
        return CustomTextField(
          initialValue: state.mqttHost.value,
          onChanged: (value) => context
              .read<ServerConfigBloc>()
              .add(ServerConfigMqttHostChanged(mqttHost: value)),
          enabled: !state.sameHost,
          labelText: 'MQTT Host',
          errorText: state.mqttHost.invalid ? error?.message : null,
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
        final error = state.mqttPort.error;
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
          errorText: state.httpHost.invalid ? error?.message : null,
          labelText: 'MQTT Port',
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
        return ListTile(
          title: const Text(
            'HTTP and MQTT share the same host',
            style: TextStyle(fontSize: 14),
          ),
          trailing: Switch(
            activeColor: Colors.red,
            value: state.sameHost,
            onChanged: (value) => context
                .read<ServerConfigBloc>()
                .add(ServerConfigSameHostToggled(sameHost: value)),
          ),
        );
      },
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
                child: const Text(
                  'Edit',
                  style: TextStyle(fontSize: 18),
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
          child: const Text(
            'Back',
            style: TextStyle(fontSize: 18),
          ),
        );
      },
    );
  }
}
