part of 'air_conditioner_action_cubit.dart';

class AirConditionerActionState extends Equatable {
  const AirConditionerActionState({
    this.fanSpeed,
    this.operationMode,
    this.temperature,
  });

  final FanSpeed? fanSpeed;
  final OperationMode? operationMode;
  final double? temperature;

  bool get isValid =>
      fanSpeed != null || operationMode != null || temperature != null;

  AirConditionerActionState copyWith({
    FanSpeed? Function()? fanSpeed,
    OperationMode? Function()? operationMode,
    double? Function()? temperature,
  }) {
    return AirConditionerActionState(
      fanSpeed: fanSpeed != null ? fanSpeed() : this.fanSpeed,
      operationMode:
          operationMode != null ? operationMode() : this.operationMode,
      temperature: temperature != null ? temperature() : this.temperature,
    );
  }

  @override
  List<Object?> get props => [
        fanSpeed,
        operationMode,
        temperature,
      ];
}
