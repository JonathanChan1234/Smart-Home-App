import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:flutter/material.dart';

class SetTemperatureButtonGroup extends StatelessWidget {
  const SetTemperatureButtonGroup({
    super.key,
    required this.capabilities,
    required this.temperature,
    required this.onTemperatureChanaged,
  });

  final AirConditionerCapabilities capabilities;
  final double? temperature;
  final void Function(double temperature)? onTemperatureChanaged;

  @override
  Widget build(BuildContext context) {
    final lowEnd = capabilities.setTemperatureLowEnd;
    final highEnd = capabilities.setTemperatureHighEnd;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: onTemperatureChanaged == null
              ? null
              : () {
                  onTemperatureChanaged!(
                    temperature == null
                        ? highEnd
                        : (temperature! + 1.0) <= highEnd
                            ? temperature! + 1.0
                            : temperature!,
                  );
                },
          icon: const Icon(Icons.add),
        ),
        Text(
          '${temperature ?? "--"}°C',
          style: TextStyle(
            color: Colors.purple.shade400,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: onTemperatureChanaged == null
              ? null
              : () {
                  onTemperatureChanaged!(
                    temperature == null
                        ? highEnd
                        : (temperature! - 1.0) >= lowEnd
                            ? temperature! - 1.0
                            : temperature!,
                  );
                },
          icon: const Icon(Icons.remove),
        ),
      ],
    );
  }
}
