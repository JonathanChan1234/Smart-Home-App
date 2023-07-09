import 'package:bloc/bloc.dart';
import 'package:devices_api/devices_api.dart';
import 'package:equatable/equatable.dart';
import 'package:home_api/home_api.dart';
import 'package:room_api/room_api.dart';

part 'devices_event.dart';
part 'devices_state.dart';

class DevicesBloc extends Bloc<DevicesEvent, DevicesState> {
  DevicesBloc({
    required SmartHome home,
    required Room room,
    required DeviceApi deviceApi,
  })  : _deviceApi = deviceApi,
        super(DevicesState(home: home, room: room)) {
    on<FetchDeviceListEvent>(
      onFetchDeviceListEvent,
    );
  }

  final DeviceApi _deviceApi;

  Future<void> onFetchDeviceListEvent(
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
    } on DeviceApiException catch (e) {
      emit(
        state.copyWith(
          status: DevicesStatus.failure,
          requestError: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DevicesStatus.failure,
          requestError: 'Something is wrong',
        ),
      );
    }
  }
}
