part of 'home_bloc.dart';

@JsonSerializable()
class HomeState extends Equatable {
  const HomeState({
    this.selectedHome,
  });

  factory HomeState.fromJson(Map<String, dynamic> json) =>
      _$HomeStateFromJson(json);

  final SmartHome? selectedHome;

  HomeState copyWith({
    SmartHome? selectedHome,
  }) {
    return HomeState(
      selectedHome: selectedHome,
    );
  }

  Map<String, dynamic> toJson() => _$HomeStateToJson(this);

  @override
  List<Object?> get props => [selectedHome];
}
