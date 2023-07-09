part of 'shade_edit_bloc.dart';

enum ShadeEditStatus { initial, loading, success, failure }

extension ShadeEditStatusX on ShadeEditStatus {
  bool get isLoadingOrSuccess =>
      this == ShadeEditStatus.loading || this == ShadeEditStatus.success;
}

class ShadeEditState extends Equatable {
  const ShadeEditState({
    this.status = ShadeEditStatus.initial,
    required this.shade,
    this.name = '',
    this.requestError = '',
  });

  final ShadeEditStatus status;
  final Shade shade;
  final String name;
  final String requestError;

  ShadeEditState copyWith({
    ShadeEditStatus? status,
    Shade? shade,
    String? name,
    String? requestError,
  }) {
    return ShadeEditState(
      status: status ?? this.status,
      shade: shade ?? this.shade,
      name: name ?? this.name,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object> get props => [
        status,
        shade,
        name,
        requestError,
      ];
}
