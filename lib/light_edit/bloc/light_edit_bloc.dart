import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lights_api/lights_api.dart';
import 'package:lights_repository/lights_repository.dart';

part 'light_edit_event.dart';
part 'light_edit_state.dart';

class LightEditBloc extends Bloc<LightEditEvent, LightEditState> {
  LightEditBloc({
    required LightsRepository lightsRepository,
    required Light light,
  })  : _lightsRepository = lightsRepository,
        super(LightEditState(light: light)) {
    on<LightEditNameChangedEvent>(_onLightEditNameChanged);
    on<LightEditSubmittedEvent>(_onLightEditSubmitted);
  }

  final LightsRepository _lightsRepository;

  void _onLightEditNameChanged(
    LightEditNameChangedEvent event,
    Emitter<LightEditState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onLightEditSubmitted(
    LightEditSubmittedEvent event,
    Emitter<LightEditState> emit,
  ) async {
    emit(state.copyWith(status: LightEditStatus.loading));
    try {
      await _lightsRepository.updateLightInRoom(
        roomId: state.light.roomId,
        lightId: state.light.id,
        name: state.name,
      );
      emit(state.copyWith(status: LightEditStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: LightEditStatus.failure,
          requestError:
              e is LightsApiException ? e.message : 'Something is wrong',
        ),
      );
    }
  }
}
