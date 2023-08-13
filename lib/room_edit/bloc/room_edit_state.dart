part of 'room_edit_bloc.dart';

enum RoomEditStatus { initial, loading, success, failure }

extension RoomEditStatusX on RoomEditStatus {
  bool get isLoadingOrSuccess =>
      this == RoomEditStatus.loading || this == RoomEditStatus.success;
}

class RoomEditState extends Equatable {
  const RoomEditState({
    this.status = RoomEditStatus.initial,
    required this.room,
    required this.name,
    this.requestError = '',
  });

  final RoomEditStatus status;
  final Room room;
  final String name;
  final String requestError;

  RoomEditState copyWith({
    RoomEditStatus? status,
    String? name,
    String? requestError,
  }) {
    return RoomEditState(
      room: room,
      name: name ?? this.name,
      status: status ?? this.status,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object> get props => [
        status,
        room,
        name,
        requestError,
      ];
}
