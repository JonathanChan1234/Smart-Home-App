import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shades_api/shades_api.dart';
import 'package:shades_repository/shades_repository.dart';

part 'shade_edit_event.dart';
part 'shade_edit_state.dart';

class ShadeEditBloc extends Bloc<ShadeEditEvent, ShadeEditState> {
  ShadeEditBloc({
    required Shade shade,
    required ShadesRepository shadesRepository,
  })  : _shadesRepository = shadesRepository,
        super(ShadeEditState(shade: shade)) {
    on<ShadeEditNameChangedEvent>(_onShadeEditNameChanged);
    on<ShadeEditSubmittedEvent>(_onShadeEditSubmitted);
  }

  final ShadesRepository _shadesRepository;

  void _onShadeEditNameChanged(
    ShadeEditNameChangedEvent event,
    Emitter<ShadeEditState> emit,
  ) {
    emit(state.copyWith(name: event.name));
  }

  Future<void> _onShadeEditSubmitted(
    ShadeEditSubmittedEvent event,
    Emitter<ShadeEditState> emit,
  ) async {
    emit(state.copyWith(status: ShadeEditStatus.loading));

    try {
      await _shadesRepository.updateShadeName(
        homeId: state.shade.homeId,
        shadeId: state.shade.id,
        name: state.name,
      );
      emit(
        state.copyWith(
          status: ShadeEditStatus.success,
          requestError: '',
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ShadeEditStatus.failure,
          requestError: error is ShadesApiException
              ? error.message
              : 'Something is wrong',
        ),
      );
    }
  }
}
