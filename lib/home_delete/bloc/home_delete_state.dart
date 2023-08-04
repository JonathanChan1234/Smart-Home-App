part of 'home_delete_bloc.dart';

enum HomeDeleteRefreshStatus { initial, loading, success, failure }

enum HomeDeleteRequestStatus { initial, loading, success, failure }

class HomeDeleteState extends Equatable {
  const HomeDeleteState({
    this.refreshStatus = HomeDeleteRefreshStatus.initial,
    this.requestStatus = HomeDeleteRequestStatus.initial,
    this.homes = const [],
    this.requestError = '',
  });

  final HomeDeleteRefreshStatus refreshStatus;
  final HomeDeleteRequestStatus requestStatus;
  final List<SmartHome> homes;
  final String requestError;

  HomeDeleteState copyWith({
    HomeDeleteRefreshStatus? refreshStatus,
    HomeDeleteRequestStatus? requestStatus,
    List<SmartHome>? homes,
    String? requestError,
  }) {
    return HomeDeleteState(
      refreshStatus: refreshStatus ?? this.refreshStatus,
      requestStatus: requestStatus ?? this.requestStatus,
      homes: homes ?? this.homes,
      requestError: requestError ?? this.requestError,
    );
  }

  @override
  List<Object> get props => [
        refreshStatus,
        requestStatus,
        homes,
        requestError,
      ];
}
