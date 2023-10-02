import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_home/air_conditioner/bloc/air_conditioner_bloc.dart';
import 'package:smart_home/air_conditioner/widgets/temperature_gauge.dart';
import 'package:smart_home/l10n/helpers/ac_translation_helper.dart';
import 'package:smart_home/l10n/l10n.dart';

class AirConditionerTile extends StatelessWidget {
  const AirConditionerTile({super.key, required this.airConditioner});

  final AirConditioner airConditioner;

  @override
  Widget build(BuildContext context) {
    final power = airConditioner.properties.power;
    final setTemperature = airConditioner.properties.setTemperature;
    final lowEnd = airConditioner.capabilities.setTemperatureLowEnd;
    final highEnd = airConditioner.capabilities.setTemperatureHighEnd;
    final localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TemperatureGauge(
                            temperature:
                                airConditioner.properties.roomTemperature,
                          ),
                          Text(
                            airConditioner.properties.operationMode
                                    ?.alias(localizations) ??
                                '?',
                            style: TextStyle(
                              fontWeight: FontWeight.w200,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        airConditioner.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: Row(
                    children: [
                      Text(
                        power ?? false ? localizations.on : localizations.off,
                      ),
                      IconButton(
                        onPressed: () => context.read<AirConditionerBloc>().add(
                              AirConditionerStatusChangedEvent(
                                deviceId: airConditioner.id,
                                properties: AirConditionerProperties(
                                  power: !(power ?? false),
                                ),
                              ),
                            ),
                        icon: Icon(
                          Icons.power_settings_new,
                          color: power ?? false ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  onPressed: power ?? false
                      ? () {
                          context.read<AirConditionerBloc>().add(
                                AirConditionerStatusChangedEvent(
                                  deviceId: airConditioner.id,
                                  properties: AirConditionerProperties(
                                    setTemperature: setTemperature == null
                                        ? highEnd
                                        : setTemperature + 1 <= highEnd
                                            ? setTemperature + 1
                                            : setTemperature,
                                  ),
                                ),
                              );
                        }
                      : null,
                  icon: const Icon(Icons.add),
                ),
                Column(
                  children: [
                    Text(
                      '${setTemperature ?? '?'}°C',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      AppLocalizations.of(context).setPoint,
                      style: TextStyle(
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: power ?? false
                      ? () {
                          context.read<AirConditionerBloc>().add(
                                AirConditionerStatusChangedEvent(
                                  deviceId: airConditioner.id,
                                  properties: AirConditionerProperties(
                                    setTemperature: setTemperature == null
                                        ? highEnd
                                        : setTemperature - 1 >= lowEnd
                                            ? setTemperature - 1
                                            : setTemperature,
                                  ),
                                ),
                              );
                        }
                      : null,
                  icon: const Icon(Icons.remove),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
