import 'package:bloc/bloc.dart';
import 'package:devices_api/devices_api.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:home_repository/home_repository.dart';
import 'package:mqtt_smarthome_client/mqtt_smarthome_client.dart';
import 'package:room_api/room_api.dart';
import 'package:smart_home_exception/smart_home_exception.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  DevicesBloc({
    required SmartHome home,
    required Room room,
    required DeviceApi deviceApi,
    required HomeRepository homeRepository,
  })  : _deviceApi = deviceApi,
        _homeRepository = homeRepository,
        super(DevicesState(home: home, room: room)) {
    on<FetchDeviceListEvent>(
      _onFetchDeviceListEvent,
    );
    on<DeviceMqttStatusSubscriptionEvent>(_onMqttStatusSubscriptionEvent);
  }

  final DeviceApi _deviceApi;
  final HomeRepository _homeRepository;

  Future<void> _onMqttStatusSubscriptionEvent(
    DeviceMqttStatusSubscriptionEvent event,
    Emitter<DevicesState> emit,
  ) async {
    await emit.forEach(
      _homeRepository.serverConnectStatus,
      onData: (serverStatus) {
        return state.copyWith(serverStatus: serverStatus);
      },
    );
  }

  Future<void> _onFetchDeviceListEvent(
    FetchDeviceListEvent event,
    Emitter<DevicesState> emit,
  ) async {
    emit(state.copyWith(status: DevicesStatus.loading));
    try {
      final devices =
          await _deviceApi.fetchDevicesInRoom(state.home.id, state.room.id);
      emit(
        state.copyWith(
          status: DevicesStatus.success,
          deviceCount: devices,
          requestError: '',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DevicesStatus.failure,
          requestError:
              e is SmartHomeException ? e.message : 'Something is wrong',
        ),
      );
    }
  }
}
