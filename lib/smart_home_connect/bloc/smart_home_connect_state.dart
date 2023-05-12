part of 'smart_home_connect_bloc.dart';

enum SmartHomeConnectStatus {
  initial,
  connecting,
  connected,
  disconnected,
  failure,
}

class SmartHomeConnectState extends Equatable {
  const SmartHomeConnectState({
    this.status = SmartHomeConnectStatus.initial,
    this.connectionError = 'Something is wrong',
    required this.home,
  });

  final SmartHomeConnectStatus status;
  final SmartHome home;
  final String connectionError;

  SmartHomeConnectState copyWith({
    SmartHomeConnectStatus? status,
    String? connectionError,
  }) {
    return SmartHomeConnectState(
      home: home,
      status: status ?? this.status,
      connectionError: connectionError ?? this.connectionError,
    );
  }

  @override
  List<Object> get props => [status, home];
}
