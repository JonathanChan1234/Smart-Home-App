import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lights_api/lights_api.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/scene_action_edit/bloc/scene_action_edit_bloc.dart';
import 'package:smart_home/scene_action_edit/widgets/light/cubit/light_action_edit_cubit.dart';
import 'package:smart_home/widgets/colored_checkbox.dart';

class LightActionEditPage extends StatelessWidget {
  const LightActionEditPage({
    super.key,
    required this.light,
    this.action,
  });

  final Device light;
  final SceneAction? action;

  @override
  Widget build(BuildContext context) {
    final lightAction = action?.action;
    return BlocProvider(
      create: (_) => LightActionEditCubit(
        action: lightAction != null ? LightAction.fromJson(lightAction) : null,
      ),
      child: LightActionEdit(
        light: light,
      ),
    );
  }
}

class LightActionEdit extends StatelessWidget {
  const LightActionEdit({
    super.key,
    required this.light,
  });

  final Device light;

  @override
  Widget build(BuildContext context) {
    final capabilities = LightCapabilities.fromJson(light.capabilities);
    final state = context.watch<LightActionEditCubit>().state;
    final sceneActionEditStatus =
        context.watch<SceneActionEditBloc>().state.status;
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        children: [
          _BrightnessActionEdit(dimmable: capabilities.dimmable),
          const Divider(),
          if (capabilities.hasColorTemperature) _ColorTemperatureActionEdit(),
          ElevatedButton(
            onPressed:
                state.isValid && !sceneActionEditStatus.isLoadingOrSuccess
                    ? () {
                        context.read<SceneActionEditBloc>().add(
                              SceneActionEditSubmittedEvent<LightAction>(
                                category: DeviceMainCategory.light,
                                device: light,
                                deviceProperties: LightAction(
                                  brightness: state.brightness,
                                  colorTemperature: state.colorTemperature,
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

class _BrightnessActionEdit extends StatelessWidget {
  const _BrightnessActionEdit({
    required this.dimmable,
  });

  final bool dimmable;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final brightness = context.watch<LightActionEditCubit>().state.brightness;

    return Column(
      children: [
        ListTile(
          title: Text(localizations.lightBrightness),
          trailing: ColoredCheckbox(
            value: brightness != null,
            onChanged: ({bool? value}) {
              if (value == null) return;
              context
                  .read<LightActionEditCubit>()
                  .lightActionEditBrightnessUpdated(value ? 0 : null);
            },
          ),
        ),
        if (brightness != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: [
                if (dimmable)
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 30,
                      trackShape: const RoundedRectSliderTrackShape(),
                      activeTrackColor: Colors.yellow,
                      inactiveTrackColor: Colors.grey.shade300,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 15,
                        pressedElevation: 8,
                      ),
                      thumbColor: Colors.white,
                      overlayShape:
                          const RoundSliderOverlayShape(overlayRadius: 10),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Slider(
                        max: 100,
                        value: brightness.toDouble(),
                        onChanged: (level) => context
                            .read<LightActionEditCubit>()
                            .lightActionEditBrightnessUpdated(level.toInt()),
                      ),
                    ),
                  )
                else
                  Switch(
                    activeColor: Colors.yellow,
                    value: brightness > 0,
                    onChanged: (value) => context
                        .read<LightActionEditCubit>()
                        .lightActionEditBrightnessUpdated(value ? 100 : 0),
                  ),
                if (dimmable)
                  Text('$brightness%')
                else
                  Text(brightness > 0 ? localizations.on : localizations.off),
              ],
            ),
          ),
      ],
    );
  }
}

class _ColorTemperatureActionEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorTemperature =
        context.watch<LightActionEditCubit>().state.colorTemperature;

    return Column(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context).lightColorTemperature),
          trailing: ColoredCheckbox(
            value: colorTemperature != null,
            onChanged: ({value}) {
              if (value == null) return;
              context
                  .read<LightActionEditCubit>()
                  .lightActionEditColorTemperatureUpdated(value ? 0 : null);
            },
          ),
        ),
        if (colorTemperature != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
            child: Row(
              children: [
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 30,
                    trackShape: const RoundedRectSliderTrackShape(),
                    activeTrackColor: Colors.yellow,
                    inactiveTrackColor: Colors.grey.shade300,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 15,
                      pressedElevation: 8,
                    ),
                    thumbColor: Colors.white,
                    overlayShape:
                        const RoundSliderOverlayShape(overlayRadius: 10),
                  ),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Slider(
                      max: 100,
                      value: colorTemperature.toDouble(),
                      onChanged: (level) => context
                          .read<LightActionEditCubit>()
                          .lightActionEditColorTemperatureUpdated(
                            level.toInt(),
                          ),
                    ),
                  ),
                ),
                Text('$colorTemperature%'),
              ],
            ),
          ),
      ],
    );
  }
}
