import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class TemperatureGauge extends StatelessWidget {
  const TemperatureGauge({super.key, required this.temperature});

  final double? temperature;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: 50,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            maximum: 40,
            canScaleToFit: true,
            radiusFactor: 1,
            showLabels: false,
            showTicks: false,
            axisLineStyle: const AxisLineStyle(thickness: 5),
            ranges: <GaugeRange>[
              GaugeRange(
                startValue: 0,
                endValue: temperature ?? 0,
                color: Colors.purpleAccent,
                startWidth: 5,
                endWidth: 5,
                gradient: SweepGradient(
                  colors: [
                    Colors.blueAccent.shade100,
                    Colors.blueAccent.shade200,
                    Colors.blueAccent.shade400,
                    Colors.purpleAccent.shade100,
                  ],
                  tileMode: TileMode.repeated,
                  endAngle: math.pi * (temperature ?? 0) / 40 / 2,
                ),
              ),
            ],
            pointers: <GaugePointer>[
              MarkerPointer(
                value: temperature ?? 0,
                markerHeight: 5,
                markerWidth: 5,
                enableDragging: true,
                markerType: MarkerType.circle,
                color: Colors.white,
                borderWidth: 2,
                borderColor: Colors.purpleAccent,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                widget: Text(
                  '${temperature?.toInt() ?? '?'}°',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
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
