import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:scene_action_api/scene_action_api.dart';

part 'light_action_edit_state.dart';

class LightActionEditCubit extends Cubit<LightActionEditState> {
  LightActionEditCubit({LightAction? action})
      : super(
          LightActionEditState(
            brightness: action?.brightness,
            colorTemperature: action?.colorTemperature,
          ),
        );

  void lightActionEditBrightnessUpdated(int? brightness) {
    emit(
      state.copyWith(
        brightness: () => brightness,
      ),
    );
  }

  void lightActionEditColorTemperatureUpdated(int? colorTemperature) {
    emit(
      state.copyWith(
        colorTemperature: () => colorTemperature,
      ),
    );
  }
}
