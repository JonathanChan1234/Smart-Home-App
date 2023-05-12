import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lights_api/lights_api.dart';
import 'package:smart_home/lights/bloc/light_bloc.dart';

class LightControl extends StatelessWidget {
  const LightControl({
    super.key,
    required this.light,
  });

  final Light light;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(light.name),
            subtitle: Text('${light.level}%'),
            trailing: Switch(
              activeColor: Colors.yellow,
              value: light.level > 0,
              onChanged: (value) => context.read<LightBloc>().add(
                    LightStatusChangedEvent(
                      deviceId: light.id,
                      brightness: light.level == 0 ? 100 : 0,
                    ),
                  ),
            ),
          ),
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
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
            ),
            child: Slider(
              max: 100,
              value: light.level.toDouble(),
              onChanged: (level) => context.read<LightBloc>().add(
                    LightStatusChangedEvent(
                      deviceId: light.id,
                      brightness: level.toInt(),
                    ),
                  ),
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
