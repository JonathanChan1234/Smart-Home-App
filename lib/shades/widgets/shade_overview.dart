import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shades_api/shades_api.dart';
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

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 9, 12, 19),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  editMode ? 'EDIT' : 'CONTROLS',
                  style: textTheme.titleSmall!.copyWith(
                    color: const Color.fromARGB(255, 222, 223, 225),
                  ),
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
                          color: Color.fromARGB(255, 222, 223, 225),
                        )
                      : const Icon(
                          Icons.mode_edit,
                          color: Color.fromARGB(255, 222, 223, 225),
                        ),
                )
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: ListView.builder(
                itemCount: shades.length,
                itemBuilder: (context, index) => editMode
                    ? ShadeEdit(shade: shades[index])
                    : ShadeControl(shade: shades[index]),
              ),
            ),
          )
        ],
      ),
    );
  }
}
