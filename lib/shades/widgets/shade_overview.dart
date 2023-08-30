import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shades_api/shades_api.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/shades/bloc/shade_bloc.dart';
import 'package:smart_home/shades/widgets/shade_control.dart';
import 'package:smart_home/shades/widgets/shade_edit.dart';

class ShadeOverview extends StatelessWidget {
  const ShadeOverview({
    super.key,
    required this.shades,
  });

  final List<Shade> shades;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final editMode = context.read<ShadeBloc>().state.editMode;
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
                onPressed: () {
                  context
                      .read<ShadeBloc>()
                      .add(ShadeEditModeChangedEvent(editMode: !editMode));
                },
                icon: editMode
                    ? const Icon(
                        Icons.edit_off,
                      )
                    : const Icon(
                        Icons.mode_edit,
                      ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ListView.builder(
              itemCount: shades.length,
              itemBuilder: (context, index) => editMode
                  ? ShadeEdit(shade: shades[index])
                  : ShadeControl(shade: shades[index]),
            ),
          ),
        ),
      ],
    );
  }
}
