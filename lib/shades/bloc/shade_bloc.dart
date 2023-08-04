import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:room_api/room_api.dart';
import 'package:shades_api/shades_api.dart';
import 'package:shades_repository/shades_repository.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'shade_event.dart';
part 'shade_state.dart';

class ShadeBloc extends Bloc<ShadeEvent, ShadeState> {
  ShadeBloc({
    required ShadesRepository shadesRepository,
    required SmartHome home,
    required Room room,
  })  : _shadesRepository = shadesRepository,
        super(ShadeState(home: home, room: room)) {
    on<ShadeListInitEvent>(_onShadeListInit);
    on<ShadeStatusSubscriptionRequestedEvent>(
      _onShadeStatusSubscriptionRequested,
    );
    on<ShadeControlEvent>(_onShadeControlEvent);
    on<ShadeEditModeChangedEvent>(_onShadeEditModeChanged);
  }

  final ShadesRepository _shadesRepository;

  Future<void> _onShadeListInit(
    ShadeListInitEvent event,
    Emitter<ShadeState> emit,
  ) async {
    emit(state.copyWith(status: ShadeStatus.loading));
    try {
      await _shadesRepository.fetchShadesInRoom(
        homeId: state.home.id,
        roomId: state.room.id,
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: ShadeStatus.failure,
          requestError: error is SmartHomeException
              ? error.message
              : 'Something is wrong',
        ),
      );
    }
  }

  Future<void> _onShadeStatusSubscriptionRequested(
    ShadeStatusSubscriptionRequestedEvent event,
    Emitter<ShadeState> emit,
  ) async {
    emit(state.copyWith(status: ShadeStatus.loading));
    _shadesRepository.initShadeStatusSubscription(state.home.id);
    await emit.forEach(
      _shadesRepository.shades,
      onData: (shades) => state.copyWith(
        status: ShadeStatus.success,
        shades: shades,
        requestError: '',
      ),
      onError: (error, _) => state.copyWith(
        status: ShadeStatus.failure,
        requestError: (error is SmartHomeException)
            ? error.message
            : 'Something is wrong',
      ),
    );
  }

  void _onShadeControlEvent(
    ShadeControlEvent event,
    Emitter<ShadeState> emit,
  ) {
    try {
      _shadesRepository.controlShade(
        homeId: state.home.id,
        deviceId: event.deviceId,
        action: event.action,
      );
    } catch (e) {
      emit(
        state.copyWith(
          controlError: e is MqttSmartHomeClientException
              ? e.message
              : 'Something is wrong',
        ),
      );
    }
  }

  void _onShadeEditModeChanged(
    ShadeEditModeChangedEvent event,
    Emitter<ShadeState> emit,
  ) {
    emit(state.copyWith(editMode: event.editMode));
  }

  @override
  Future<void> close() {
    super.close();
    return _shadesRepository.dispose();
  }
}
