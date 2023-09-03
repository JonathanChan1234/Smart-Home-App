import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/l10n/helpers/ac_translation_helper.dart';
import 'package:smart_home/l10n/l10n.dart';

class FanSpeedSelect extends StatelessWidget {
  const FanSpeedSelect({
    super.key,
    required this.capabilities,
    required this.fanSpeed,
    required this.onFanSpeedChanged,
  });

  final AirConditionerCapabilities capabilities;
  final FanSpeed? fanSpeed;
  final void Function(FanSpeed fanSpeed) onFanSpeedChanged;

  @override
  Widget build(BuildContext context) {
    final fanModes = <FanSpeed>[
      if (capabilities.autoFanSpeed) FanSpeed.auto,
      if (capabilities.quietFanSpeed) FanSpeed.quiet,
      if (capabilities.lowFanSpeed) FanSpeed.low,
      if (capabilities.mediumFanSpeed) FanSpeed.medium,
      if (capabilities.highFanSpeed) FanSpeed.high,
      if (capabilities.topFanSpeed) FanSpeed.top,
    ];
    final localizations = AppLocalizations.of(context);

    Future<void> showFanSpeedOptions() async {
      final fanSpeed = await showModalBottomSheet<FanSpeed?>(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: fanModes.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  fanModes[index].alias(localizations),
                  style: const TextStyle(color: Colors.black),
                ),
                onTap: () => Navigator.of(context).pop(fanModes[index]),
              );
            },
          );
        },
      );
      if (fanSpeed == null) return;
      onFanSpeedChanged(fanSpeed);
    }

    return TextButton(
      onPressed: showFanSpeedOptions,
      child: Column(
        children: [
          Text(
            fanSpeed?.alias(localizations) ?? '--',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            localizations.acFanSpeedTitle,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
