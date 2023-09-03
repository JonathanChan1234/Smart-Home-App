import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/l10n/helpers/ac_translation_helper.dart';
import 'package:smart_home/l10n/l10n.dart';

class OperationModeSelect extends StatelessWidget {
  const OperationModeSelect({
    super.key,
    required this.capabilities,
    required this.operationMode,
    required this.onOperationModeChanged,
  });

  final AirConditionerCapabilities capabilities;
  final OperationMode? operationMode;
  final void Function(OperationMode operationMode) onOperationModeChanged;

  @override
  Widget build(BuildContext context) {
    final operationModes = <OperationMode>[
      if (capabilities.autoMode) OperationMode.auto,
      if (capabilities.fanMode) OperationMode.fan,
      if (capabilities.heatMode) OperationMode.heat,
      if (capabilities.coolMode) OperationMode.cool,
      if (capabilities.dryMode) OperationMode.dry,
    ];
    final localizations = AppLocalizations.of(context);

    Future<void> showOperationModeOptions() async {
      final operationMode = await showModalBottomSheet<OperationMode?>(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: operationModes.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(
                  operationModes[index].alias(localizations),
                  style: const TextStyle(color: Colors.black),
                ),
                onTap: () => Navigator.of(context).pop(operationModes[index]),
              );
            },
          );
        },
      );
      if (operationMode == null) return;
      onOperationModeChanged(operationMode);
    }

    return TextButton(
      onPressed: showOperationModeOptions,
      child: Column(
        children: [
          Text(
            operationMode?.alias(localizations) ?? '--',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            localizations.acOperationModeTitle,
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
