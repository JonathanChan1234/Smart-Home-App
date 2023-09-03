part of 'air_conditioner_edit_bloc.dart';

enum AirConditionerEditStatus { initial, loading, success, failure }

extension AirConditionerEditStatusX on AirConditionerEditStatus {
  bool get isLoadingOrSuccess =>
      this == AirConditionerEditStatus.loading ||
      this == AirConditionerEditStatus.success;
}

class AirConditionerEditState extends Equatable {
  const AirConditionerEditState({
    this.status = AirConditionerEditStatus.initial,
    required this.airConditioner,
    this.name = '',
    this.requestError,
  });

  final AirConditionerEditStatus status;
  final AirConditioner airConditioner;
  final String name;
  final String? requestError;

  AirConditionerEditState copyWith({
    AirConditionerEditStatus? status,
    AirConditioner? airConditioner,
    String? name,
    String? requestError,
  }) {
    return AirConditionerEditState(
      status: status ?? this.status,
      airConditioner: airConditioner ?? this.airConditioner,
      name: name ?? this.name,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object?> get props => [status, airConditioner, name, requestError];
}
