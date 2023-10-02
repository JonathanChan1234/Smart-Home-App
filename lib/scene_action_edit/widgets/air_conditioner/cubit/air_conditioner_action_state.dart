part of 'air_conditioner_action_cubit.dart';

class AirConditionerActionState extends Equatable {
  const AirConditionerActionState({
    this.power = true,
    this.fanSpeed,
    this.operationMode,
    this.temperature,
  });

  final bool power;
  final FanSpeed? fanSpeed;
  final OperationMode? operationMode;
  final double? temperature;

  AirConditionerActionState copyWith({
    bool? power,
    FanSpeed? Function()? fanSpeed,
    OperationMode? Function()? operationMode,
    double? Function()? temperature,
  }) {
    return AirConditionerActionState(
      power: power ?? this.power,
      fanSpeed: fanSpeed != null ? fanSpeed() : this.fanSpeed,
      operationMode:
          operationMode != null ? operationMode() : this.operationMode,
      temperature: temperature != null ? temperature() : this.temperature,
    );
  }

  @override
  List<Object?> get props => [
        power,
        fanSpeed,
        operationMode,
        temperature,
      ];
}
