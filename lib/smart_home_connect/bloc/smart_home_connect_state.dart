part of 'smart_home_connect_bloc.dart';

enum SmartHomeServerConnectStatus {
  initial,
  connecting,
  connected,
  disconnected,
  failure,
}

class SmartHomeConnectState extends Equatable {
  const SmartHomeConnectState({
    this.serverConnectStatus = SmartHomeServerConnectStatus.initial,
    this.processorConnectStatus = ProcessorConnectionStatus.initial,
    this.connectionError = 'Something is wrong',
    required this.home,
  });

  final SmartHomeServerConnectStatus serverConnectStatus;
  final ProcessorConnectionStatus processorConnectStatus;
  final SmartHome home;
  final String connectionError;

  SmartHomeConnectState copyWith({
    SmartHomeServerConnectStatus? serverConnectStatus,
    ProcessorConnectionStatus? processorConnectStatus,
    String? connectionError,
  }) {
    return SmartHomeConnectState(
      home: home,
      serverConnectStatus: serverConnectStatus ?? this.serverConnectStatus,
      processorConnectStatus:
          processorConnectStatus ?? this.processorConnectStatus,
      connectionError: connectionError ?? this.connectionError,
    );
  }

  @override
  List<Object> get props => [
        serverConnectStatus,
        processorConnectStatus,
        home,
        connectionError,
      ];
}
