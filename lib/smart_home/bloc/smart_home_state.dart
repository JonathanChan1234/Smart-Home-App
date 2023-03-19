part of 'smart_home_bloc.dart';

enum SmartHomeStatus {
  initial,
  loading,
  success,
  failure,
}

@JsonSerializable()
class SmartHomeState extends Equatable {
  const SmartHomeState({
    this.status = SmartHomeStatus.initial,
    this.smartHome = const [],
    this.errorMessage = '',
  });

  factory SmartHomeState.fromJson(Map<String, dynamic> json) =>
      _$SmartHomeStateFromJson(json);

  final SmartHomeStatus status;
  final List<SmartHome> smartHome;
  final String errorMessage;

  SmartHomeState copyWith({
    SmartHomeStatus? status,
    List<SmartHome>? smartHome,
    String? errorMessage,
  }) {
    return SmartHomeState(
      status: status ?? this.status,
      smartHome: smartHome ?? this.smartHome,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  Map<String, dynamic> toJson() => _$SmartHomeStateToJson(this);

  @override
  List<Object> get props => [status, smartHome];
}
