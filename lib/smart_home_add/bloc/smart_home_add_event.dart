part of 'smart_home_add_bloc.dart';

abstract class SmartHomeAddEvent extends Equatable {
  const SmartHomeAddEvent();

  @override
  List<Object> get props => [];
}

class SmartHomeQRcodeScannedEvent extends SmartHomeAddEvent {
  const SmartHomeQRcodeScannedEvent({required this.rawData});

  final String rawData;
}
