part of 'light_edit_bloc.dart';

enum LightEditStatus { initial, loading, success, failure }

extension LightEditStatusX on LightEditStatus {
  bool get isLoadingOrSuccess =>
      this == LightEditStatus.loading || this == LightEditStatus.success;
}

class LightEditState extends Equatable {
  const LightEditState({
    this.status = LightEditStatus.initial,
    required this.light,
    this.name = '',
    this.requestError = '',
  });

  final LightEditStatus status;
  final Light light;
  final String name;
  final String requestError;

  LightEditState copyWith({
    LightEditStatus? status,
    Light? light,
    String? name,
    String? requestError,
  }) {
    return LightEditState(
      status: status ?? this.status,
      light: light ?? this.light,
      name: name ?? this.name,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object> get props => [status, light, name, requestError];
}
