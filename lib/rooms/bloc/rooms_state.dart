part of 'rooms_bloc.dart';

enum RoomsStatus { initial, loading, success, failure }

class RoomsState extends Equatable {
  const RoomsState({
    required this.home,
    this.floors = const [],
    this.status = RoomsStatus.initial,
    this.isFavorite = false,
    this.selectedFloor,
    this.requestError = '',
  });

  final RoomsStatus status;
  final SmartHome home;
  final List<Floor> floors;
  final bool isFavorite;
  final Floor? selectedFloor;
  final String requestError;

  RoomsState copyWith({
    List<Floor> Function()? floors,
    RoomsStatus Function()? status,
    bool Function()? isFavorite,
    Floor? Function()? selectedFloor,
    String Function()? requestError,
  }) {
    return RoomsState(
      home: home,
      floors: floors != null ? floors() : this.floors,
      status: status != null ? status() : this.status,
      isFavorite: isFavorite != null ? isFavorite() : this.isFavorite,
      selectedFloor:
          selectedFloor != null ? selectedFloor() : this.selectedFloor,
      requestError: requestError != null ? requestError() : this.requestError,
    );
  }

  @override
  List<Object?> get props => [
        home,
        floors,
        status,
        selectedFloor,
        isFavorite,
        requestError,
      ];
}
