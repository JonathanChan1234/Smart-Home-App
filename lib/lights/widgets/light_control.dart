import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lights_api/lights_api.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:smart_home/lights/bloc/light_bloc.dart';

class LightControl extends StatelessWidget {
  const LightControl({
    super.key,
    required this.light,
  });

  final Light light;

  @override
  Widget build(BuildContext context) {
    final brightness = light.properties.brightness ?? 0;
    final dimmable = light.capabilities.dimmable;
    final localizations = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(light.name),
            subtitle: light.properties.brightness == null
                ? const Text('--')
                : dimmable
                    ? Text('$brightness%')
                    : Text(
                        brightness > 0 ? localizations.on : localizations.off,
                      ),
            trailing: Switch(
              activeColor: Colors.yellow,
              value: brightness > 0,
              onChanged: light.onlineStatus
                  ? (value) => context.read<LightBloc>().add(
                        LightStatusChangedEvent(
                          deviceId: light.id,
                          properties: light.properties.copyWith(
                            brightness: () => brightness == 0 ? 100 : 0,
                          ),
                        ),
                      )
                  : null,
            ),
          ),
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
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
              ),
              child: Slider(
                max: 100,
                value: brightness.toDouble(),
                onChanged: (level) => light.onlineStatus
                    ? context.read<LightBloc>().add(
                          LightStatusChangedEvent(
                            deviceId: light.id,
                            properties:
                                LightProperties(brightness: level.toInt()),
                          ),
                        )
                    : null,
              ),
            ),
          const Divider(),
        ],
      ),
    );
  }
}
