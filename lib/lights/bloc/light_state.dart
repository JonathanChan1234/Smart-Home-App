part of 'light_bloc.dart';

enum LightStatus { initial, loading, success, failure }

class LightState extends Equatable {
  const LightState({
    required this.home,
    required this.room,
    this.status = LightStatus.initial,
    this.lights = const [],
    this.requestError = '',
    this.controlError = '',
    this.editMode = false,
  });

  final SmartHome home;
  final Room room;
  final LightStatus status;
  final List<Light> lights;
  final String requestError;
  final String controlError;
  final bool editMode;

  LightState copyWith({
    LightStatus? status,
    List<Light>? lights,
    String? requestError,
    String? controlError,
    bool? editMode,
  }) {
    return LightState(
      home: home,
      room: room,
      status: status ?? this.status,
      lights: lights ?? this.lights,
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
        lights,
        requestError,
        controlError,
        editMode,
      ];
}
