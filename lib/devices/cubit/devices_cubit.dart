import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smart_home/rooms/models/room.dart';

part 'devices_state.dart';

class DevicesCubit extends Cubit<DevicesState> {
  DevicesCubit(Room room) : super(DevicesState(room: room));
}
