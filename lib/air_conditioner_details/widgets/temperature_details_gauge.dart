import 'dart:math' as math;

import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:flutter/material.dart';
import 'package:smart_home/icons/custom_icons.dart';
import 'package:smart_home/l10n/l10n.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TemperatureDetailsGauge extends StatelessWidget {
  const TemperatureDetailsGauge({
    super.key,
    required this.airConditioner,
    this.minValue = 0,
    this.maxValue = 40,
  });

  final AirConditioner airConditioner;
  final double minValue;
  final double maxValue;

  @override
  Widget build(BuildContext context) {
    final difference = maxValue - minValue;
    final temperature = airConditioner.capabilities.showRoomTemperature
        ? airConditioner.properties.roomTemperature
        : airConditioner.properties.setTemperature;

    Icon getOperationModeIcon() {
      switch (airConditioner.properties.operationMode) {
        case OperationMode.fan:
          return const Icon(
            CustomIcons.fan,
            size: 25,
            color: Colors.blue,
          );
        case OperationMode.heat:
          return const Icon(CustomIcons.fire, size: 25, color: Colors.red);
        case OperationMode.cool:
          return const Icon(
            CustomIcons.frost_emblem,
            size: 25,
            color: Colors.blueAccent,
          );
        case OperationMode.dry:
          return const Icon(Icons.water_drop, size: 25, color: Colors.blue);
        case OperationMode.auto:
          return const Icon(
            CustomIcons.brightness_auto,
            size: 25,
            color: Colors.yellow,
          );
        case null:
          return const Icon(
            Icons.question_mark_outlined,
            size: 25,
          );
      }
    }

    return SizedBox(
      height: 225,
      width: 225,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            maximum: maxValue,
            minimum: minValue,
            canScaleToFit: true,
            radiusFactor: 0.8,
            showLabels: false,
            showTicks: false,
            axisLineStyle: const AxisLineStyle(thickness: 5),
            startAngle: 110,
            endAngle: 70,
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: airConditioner.properties.roomTemperature ?? 0,
                color: Colors.purpleAccent,
                startWidth: 5,
                endWidth: 5,
                gradient: SweepGradient(
                  colors: [
                    Colors.blue.shade100,
                    Colors.blue.shade200,
                    Colors.blue.shade300,
                    Colors.blue.shade400,
                    Colors.blue.shade500,
                    Colors.blue.shade600,
                    Colors.blue.shade700,
                  ],
                  tileMode: TileMode.repeated,
                  endAngle: math.pi * (temperature ?? 0) * 2 / maxValue,
                ),
              ),
              GaugeRange(
                startValue: temperature ?? 0,
                endValue: 40,
                color: Colors.purpleAccent,
                startWidth: 5,
                endWidth: 5,
                gradient: SweepGradient(
                  colors: [
                    Colors.purpleAccent.shade200,
                    Colors.purpleAccent.shade400,
                    Colors.redAccent.shade400,
                  ],
                  tileMode: TileMode.repeated,
                  endAngle: math.pi * (temperature ?? 0) * 2 / maxValue,
                ),
              ),
            ],
            pointers: <GaugePointer>[
              WidgetPointer(
                value: temperature ?? 0,
                offset: -5,
                child: Transform.rotate(
                  angle: math.pi *
                      ((temperature ?? 0) - difference / 2) *
                      (160 / (difference / 2)) /
                      180,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 15,
                        width: 15,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.red),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                        width: 5,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: getOperationModeIcon(),
                    ),
                    Text(
                      '${temperature ?? "--"}°C',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      AppLocalizations.of(context).currentTemperature,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                positionFactor: 0.1,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
