part of 'smart_home_overview_bloc.dart';

enum SmartHomeOverviewStatus {
  initial,
  loading,
  success,
  failure,
}

enum SmartHomeOverviewEventType {
  fetch,
  add,
  delete,
}

enum SmartHomeTab { home, settings }

@JsonSerializable()
class SmartHomeOverviewState extends Equatable {
  const SmartHomeOverviewState({
    this.tab = SmartHomeTab.home,
    this.status = SmartHomeOverviewStatus.initial,
    this.homes = const [],
    this.requestError = '',
    this.eventType = SmartHomeOverviewEventType.fetch,
  });

  factory SmartHomeOverviewState.fromJson(Map<String, dynamic> json) =>
      _$SmartHomeOverviewStateFromJson(json);

  final SmartHomeTab tab;
  final SmartHomeOverviewStatus status;
  final SmartHomeOverviewEventType eventType;
  final List<SmartHome> homes;
  final String requestError;

  SmartHomeOverviewState copyWith({
    SmartHomeTab? tab,
    SmartHomeOverviewStatus? status,
    SmartHomeOverviewEventType? eventType,
    List<SmartHome>? homes,
    String? requestError,
  }) {
    return SmartHomeOverviewState(
      tab: tab ?? this.tab,
      status: status ?? this.status,
      eventType: eventType ?? this.eventType,
      homes: homes ?? this.homes,
      requestError: requestError ?? this.requestError,
    );
  }

  Map<String, dynamic> toJson() => _$SmartHomeOverviewStateToJson(this);

  @override
  List<Object> get props => [
        tab,
        status,
        eventType,
        homes,
        requestError,
      ];
}
