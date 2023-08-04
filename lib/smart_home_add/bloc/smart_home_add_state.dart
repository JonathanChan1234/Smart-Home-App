part of 'smart_home_add_bloc.dart';

enum SmartHomeAddStatus {
  initial,
  loading,
  success,
  failure,
}

class SmartHomeAddState extends Equatable {
  const SmartHomeAddState({
    this.status = SmartHomeAddStatus.initial,
    this.requestError = '',
    this.home,
  });

  final SmartHomeAddStatus status;
  final SmartHome? home;
  final String? requestError;

  SmartHomeAddState copyWith({
    SmartHomeAddStatus? status,
    SmartHome? home,
    String? requestError,
  }) {
    return SmartHomeAddState(
      status: status ?? this.status,
      home: home ?? this.home,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object?> get props => [
        status,
        home,
        requestError,
      ];
}
