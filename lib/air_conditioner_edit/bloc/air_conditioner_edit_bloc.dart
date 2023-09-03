import 'package:air_conditioner_api/air_conditioner_api.dart';
import 'package:air_conditioner_repository/air_conditioner_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'air_conditioner_edit_event.dart';
part 'air_conditioner_edit_state.dart';

class AirConditionerEditBloc
    extends Bloc<AirConditionerEditEvent, AirConditionerEditState> {
  AirConditionerEditBloc({
    required AirConditioner airConditioner,
    required AirConditionerRepository airConditionerRepository,
  })  : _airConditionerRepository = airConditionerRepository,
        super(
          AirConditionerEditState(
            airConditioner: airConditioner,
            name: airConditioner.name,
          ),
        ) {
    on<AirConditionerEditNameChangedEvent>(_onNameChanged);
    on<AirConditionerEditFormSubmitEvent>(_onEditFormSubmit);
  }

  final AirConditionerRepository _airConditionerRepository;

  void _onNameChanged(
    AirConditionerEditNameChangedEvent event,
    Emitter<AirConditionerEditState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onEditFormSubmit(
    AirConditionerEditFormSubmitEvent event,
    Emitter<AirConditionerEditState> emit,
  ) async {
    emit(
      state.copyWith(
        status: AirConditionerEditStatus.loading,
        requestError: '',
      ),
    );
    try {
      await _airConditionerRepository.updateAcInRoom(
        homeId: state.airConditioner.homeId,
        deviceId: state.airConditioner.id,
        name: state.name,
      );
      emit(
        state.copyWith(
          status: AirConditionerEditStatus.success,
          requestError: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: AirConditionerEditStatus.failure,
          requestError:
              e is SmartHomeException ? e.message : 'Something is wrong',
        ),
      );
    }
  }
}
