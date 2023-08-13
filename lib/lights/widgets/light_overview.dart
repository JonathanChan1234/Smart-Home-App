import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lights_api/lights_api.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/lights/bloc/light_bloc.dart';
import 'package:smart_home/lights/widgets/light_control.dart';
import 'package:smart_home/lights/widgets/light_edit.dart';

class LightOverview extends StatelessWidget {
  const LightOverview({
    super.key,
    required this.lights,
  });

  final List<Light> lights;

  @override
  Widget build(BuildContext context) {
    final editMode = context.read<LightBloc>().state.editMode;
    final textTheme = Theme.of(context).textTheme;
    final localizations = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                editMode ? localizations.edit : localizations.control,
                style: textTheme.titleSmall,
              ),
              IconButton(
                icon: editMode
                    ? const Icon(Icons.edit_off)
                    : const Icon(Icons.mode_edit),
                onPressed: () {
                  context
                      .read<LightBloc>()
                      .add(LightEditModeChangedEvent(editMode: !editMode));
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: lights.length,
              itemBuilder: (context, index) => editMode
                  ? LightEdit(
                      light: lights[index],
                    )
                  : LightControl(light: lights[index]),
            ),
          ),
        )
      ],
    );
  }
}
