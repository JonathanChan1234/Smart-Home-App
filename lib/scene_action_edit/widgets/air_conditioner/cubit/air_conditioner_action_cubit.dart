import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scene_action_api/scene_action_api.dart';

part 'air_conditioner_action_state.dart';

class AirConditionerActionCubit extends Cubit<AirConditionerActionState> {
  AirConditionerActionCubit({AirConditionerAction? action})
      : super(
          AirConditionerActionState(
            fanSpeed: action?.fanSpeed,
            operationMode: action?.operationMode,
            temperature: action?.setTemperature,
          ),
        );

  void airConditionerActionPowerUpdated() {
    emit(state.copyWith(power: !state.power));
  }

  void airConditionerActionFanSpeedUpdated(FanSpeed? fanSpeed) {
    emit(state.copyWith(fanSpeed: () => fanSpeed));
  }

  void airConditionerActionOperationModeUpdated(OperationMode? operationMode) {
    emit(state.copyWith(operationMode: () => operationMode));
  }

  void airConditionerActionTemperatureChanged(double? temperature) {
    emit(state.copyWith(temperature: () => temperature));
  }
}
