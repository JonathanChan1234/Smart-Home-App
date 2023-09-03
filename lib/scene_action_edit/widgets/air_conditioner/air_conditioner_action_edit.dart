import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:smart_home/air_conditioner_details/widgets/fan_speed_select.dart';
import 'package:smart_home/air_conditioner_details/widgets/operation_mode_select.dart';
import 'package:smart_home/air_conditioner_details/widgets/set_temperature_button_group.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/scene_action_edit/bloc/scene_action_edit_bloc.dart';
import 'package:smart_home/scene_action_edit/widgets/air_conditioner/cubit/air_conditioner_action_cubit.dart';
import 'package:smart_home/widgets/colored_checkbox.dart';

class AirConditionerActionEditPage extends StatelessWidget {
  const AirConditionerActionEditPage({
    super.key,
    required this.airConditioner,
    this.action,
  });

  final Device airConditioner;
  final SceneAction? action;

  @override
  Widget build(BuildContext context) {
    final airConditionerAction = action?.action;
    return BlocProvider(
      create: (_) => AirConditionerActionCubit(
        action: airConditionerAction != null
            ? AirConditionerAction.fromJson(airConditionerAction)
            : null,
      ),
      child: AirConditionerActionEdit(
        airConditioner: airConditioner,
      ),
    );
  }
}

class AirConditionerActionEdit extends StatelessWidget {
  const AirConditionerActionEdit({
    super.key,
    required this.airConditioner,
  });

  final Device airConditioner;

  @override
  Widget build(BuildContext context) {
    final capabilities =
        AirConditionerCapabilities.fromJson(airConditioner.capabilities);
    final state = context.watch<AirConditionerActionCubit>().state;
    final sceneActionEditStatus =
        context.watch<SceneActionEditBloc>().state.status;
    final theme = Theme.of(context);
    final localizations = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (capabilities.defaultFanSpeed != null)
            SceneActionTile(
              enabled: state.fanSpeed != null,
              title: localizations.acFanSpeed,
              widget: FanSpeedSelect(
                capabilities: capabilities,
                fanSpeed: state.fanSpeed,
                onFanSpeedChanged: (fanSpeed) => context
                    .read<AirConditionerActionCubit>()
                    .airConditionerActionFanSpeedUpdated(fanSpeed),
              ),
              onEnabledChanged: ({required enabled}) => context
                  .read<AirConditionerActionCubit>()
                  .airConditionerActionFanSpeedUpdated(
                    enabled ? capabilities.defaultFanSpeed : null,
                  ),
            ),
          if (capabilities.defaultOperationMode != null)
            SceneActionTile(
              enabled: state.operationMode != null,
              title: localizations.acOperationMode,
              widget: OperationModeSelect(
                capabilities: capabilities,
                operationMode: state.operationMode,
                onOperationModeChanged: (operationMode) => context
                    .read<AirConditionerActionCubit>()
                    .airConditionerActionOperationModeUpdated(operationMode),
              ),
              onEnabledChanged: ({required enabled}) => context
                  .read<AirConditionerActionCubit>()
                  .airConditionerActionOperationModeUpdated(
                    enabled ? capabilities.defaultOperationMode : null,
                  ),
            ),
          SceneActionTile(
            enabled: state.temperature != null,
            title: localizations.currentTemperature,
            widget: SetTemperatureButtonGroup(
              capabilities: capabilities,
              temperature: state.temperature,
              onTemperatureChanaged: (temperature) => context
                  .read<AirConditionerActionCubit>()
                  .airConditionerActionTemperatureChanged(temperature),
            ),
            onEnabledChanged: ({required enabled}) => context
                .read<AirConditionerActionCubit>()
                .airConditionerActionTemperatureChanged(
                    enabled ? capabilities.setTemperatureHighEnd : null),
          ),
          ElevatedButton(
            onPressed: state.isValid &&
                    !sceneActionEditStatus.isLoadingOrSuccess
                ? () {
                    context.read<SceneActionEditBloc>().add(
                          SceneActionEditSubmittedEvent<AirConditionerAction>(
                            category: DeviceMainCategory.ac,
                            device: airConditioner,
                            deviceProperties: AirConditionerAction(
                              fanSpeed: state.fanSpeed,
                              operationMode: state.operationMode,
                              setTemperature: state.temperature,
                            ),
                          ),
                        );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              disabledBackgroundColor: Colors.grey,
            ),
            child: Text(
              AppLocalizations.of(context).submit,
              style: theme.textTheme.titleSmall!.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SceneActionTile extends StatelessWidget {
  const SceneActionTile({
    super.key,
    required this.enabled,
    required this.title,
    required this.widget,
    required this.onEnabledChanged,
  });

  final void Function({required bool enabled}) onEnabledChanged;
  final bool enabled;
  final String title;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          trailing: ColoredCheckbox(
            value: enabled,
            onChanged: ({bool? value}) {
              if (value == null) return;
              onEnabledChanged(enabled: value);
            },
          ),
        ),
        if (enabled) widget,
        const Divider(),
      ],
    );
  }
}
