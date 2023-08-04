import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scene_action_api/scene_action_api.dart';
import 'package:shades_api/shades_api.dart';
import 'package:smart_home/scene_action_edit/bloc/scene_action_edit_bloc.dart';
import 'package:smart_home/scene_action_edit/widgets/shade/cubit/shade_action_edit_cubit.dart';
import 'package:smart_home/shades/widgets/shade_slider_thumb.dart';
import 'package:smart_home/widgets/colored_checkbox.dart';

class ShadeActionEditPage extends StatelessWidget {
  const ShadeActionEditPage({
    super.key,
    required this.shade,
    this.action,
  });

  final Device shade;
  final SceneAction? action;

  @override
  Widget build(BuildContext context) {
    final shadeAction = action?.action;

    return BlocProvider(
      create: (_) => ShadeActionEditCubit(
        action: shadeAction != null ? ShadeAction.fromJson(shadeAction) : null,
      ),
      child: ShadeActionEdit(shade: shade),
    );
  }
}

class ShadeActionEdit extends StatelessWidget {
  const ShadeActionEdit({super.key, required this.shade});

  final Device shade;

  @override
  Widget build(BuildContext context) {
    final capabilities = ShadeCapabilities.fromJson(shade.capabilities);
    final state = context.watch<ShadeActionEditCubit>().state;
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
          if (capabilities.hasLevel)
            _ShadeActionLevelEdit()
          else
            _ShadeActionTypeEdit(),
          const Divider(),
          ElevatedButton(
            onPressed:
                state.isValid && !sceneActionEditStatus.isLoadingOrSuccess
                    ? () {
                        context.read<SceneActionEditBloc>().add(
                              SceneActionEditSubmittedEvent<ShadeAction>(
                                category: DeviceMainCategory.shade,
                                device: shade,
                                deviceProperties: ShadeAction(
                                  level: state.level,
                                  actionType: state.actionType,
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
              'Submit',
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

class _ShadeActionLevelEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final level = context.watch<ShadeActionEditCubit>().state.level;
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        ListTile(
          title: const Text('Level'),
          trailing: ColoredCheckbox(
            value: level != null,
            onChanged: (bool? value) {
              if (value == null) return;
              context
                  .read<ShadeActionEditCubit>()
                  .shadeActionEditLevelChanged(value ? 0 : null);
            },
          ),
        ),
        if (level != null)
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 3,
              activeTrackColor: const Color.fromARGB(255, 223, 224, 227),
              inactiveTrackColor: const Color.fromARGB(255, 70, 73, 80),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 2),
              thumbShape: ShadeSliderThumb(
                height: 30,
                width: 50,
                sliderValue: level.toDouble(),
              ),
            ),
            child: SizedBox(
              width: width * 0.85,
              child: Slider(
                max: 100,
                divisions: 100,
                value: level.toDouble(),
                onChanged: (value) {
                  context
                      .read<ShadeActionEditCubit>()
                      .shadeActionEditLevelChanged(value.toInt());
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _ShadeActionTypeEdit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final actionType = context.watch<ShadeActionEditCubit>().state.actionType;
    return Column(
      children: [
        ListTile(
          title: const Text('Action Type'),
          trailing: ColoredCheckbox(
            value: actionType != null,
            onChanged: (value) {
              if (value == null) return;
              context
                  .read<ShadeActionEditCubit>()
                  .shadeActionEditActionTypeChanged(
                    value ? ShadeActionType.lower : null,
                  );
            },
          ),
        ),
        if (actionType != null)
          for (final action in ShadeActionType.values)
            if (action != ShadeActionType.na)
              ListTile(
                title: Text(action.name),
                leading: Radio<ShadeActionType>(
                  value: action,
                  groupValue: actionType,
                  onChanged: (ShadeActionType? value) {
                    if (value == null) return;
                    context
                        .read<ShadeActionEditCubit>()
                        .shadeActionEditActionTypeChanged(value);
                  },
                ),
              ),
      ],
    );
  }
}
