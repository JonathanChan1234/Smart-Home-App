import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shades_api/shades_api.dart';
import 'package:shades_repository/shades_repository.dart';
import 'package:smart_home/shades/bloc/shade_bloc.dart';
import 'package:smart_home/shades/widgets/shade_slider_thumb.dart';
import 'package:smart_home/widgets/circular_button.dart';

class ShadeControl extends StatelessWidget {
  const ShadeControl({
    super.key,
    required this.shade,
  });

  final Shade shade;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 34, 37, 44),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              shade.name,
              style: const TextStyle(
                color: Color.fromARGB(255, 119, 120, 124),
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (shade.capabilities.hasLevel)
                  _ShadeSliderControl(shade: shade)
                else
                  _ShadeButtonControl(shade: shade),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ShadeSliderControl extends StatelessWidget {
  const _ShadeSliderControl({required this.shade});

  final Shade shade;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final level = shade.properties.level?.toDouble() ?? 0;
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 3,
        activeTrackColor: const Color.fromARGB(255, 223, 224, 227),
        inactiveTrackColor: const Color.fromARGB(255, 70, 73, 80),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 2),
        thumbShape: ShadeSliderThumb(
          height: 30,
          width: 50,
          sliderValue: level,
        ),
      ),
      child: SizedBox(
        width: width * 0.85,
        child: Slider(
          max: 100,
          divisions: 100,
          value: level,
          onChanged: (value) {
            context.read<ShadeBloc>().add(
                  ShadeControlEvent(
                    deviceId: shade.id,
                    action: ShadeAction(level: value.toInt()),
                  ),
                );
          },
        ),
      ),
    );
  }
}

class _ShadeButtonControl extends StatelessWidget {
  const _ShadeButtonControl({required this.shade});

  final Shade shade;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width * 0.85,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularButton(
            icon: Icons.chevron_left_sharp,
            onPressed: () => context.read<ShadeBloc>().add(
                  ShadeControlEvent(
                    deviceId: shade.id,
                    action:
                        const ShadeAction(actionType: ShadeActionType.lower),
                  ),
                ),
          ),
          CircularButton(
            icon: Icons.stop,
            onPressed: () => context.read<ShadeBloc>().add(
                  ShadeControlEvent(
                    deviceId: shade.id,
                    action: const ShadeAction(actionType: ShadeActionType.stop),
                  ),
                ),
          ),
          CircularButton(
            icon: Icons.chevron_right_sharp,
            onPressed: () => context.read<ShadeBloc>().add(
                  ShadeControlEvent(
                    deviceId: shade.id,
                    action:
                        const ShadeAction(actionType: ShadeActionType.lower),
                  ),
                ),
          ),
        ],
      ),
    );
  }
}
