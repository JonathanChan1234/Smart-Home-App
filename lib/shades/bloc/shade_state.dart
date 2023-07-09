part of 'shade_bloc.dart';

enum ShadeStatus { initial, loading, success, failure }

class ShadeState extends Equatable {
  const ShadeState({
    required this.home,
    required this.room,
    this.status = ShadeStatus.initial,
    this.shades = const [],
    this.requestError = '',
    this.controlError = '',
    this.editMode = false,
  });

  final SmartHome home;
  final Room room;
  final ShadeStatus status;
  final List<Shade> shades;
  final String requestError;
  final String controlError;
  final bool editMode;

  ShadeState copyWith({
    ShadeStatus? status,
    List<Shade>? shades,
    String? requestError,
    String? controlError,
    bool? editMode,
  }) {
    return ShadeState(
      home: home,
      room: room,
      status: status ?? this.status,
      shades: shades ?? this.shades,
      requestError: requestError ?? this.requestError,
      controlError: controlError ?? this.controlError,
      editMode: editMode ?? this.editMode,
    );
  }

  @override
  List<Object> get props => [
        home,
        room,
        status,
        shades,
        requestError,
        controlError,
        editMode,
      ];
}
