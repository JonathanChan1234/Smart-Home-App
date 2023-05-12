part of 'light_bloc.dart';

abstract class LightEvent extends Equatable {
  const LightEvent();

  @override
  List<Object?> get props => [];
}

class LightStatusSubscriptionRequestedEvent extends LightEvent {
  const LightStatusSubscriptionRequestedEvent();
}

class LightListInitEvent extends LightEvent {
  const LightListInitEvent();
}

class LightStatusChangedEvent extends LightEvent {
  const LightStatusChangedEvent({
    required this.deviceId,
    required this.brightness,
  });

  final String deviceId;
  final int brightness;

  @override
  List<Object?> get props => [deviceId, brightness];
}

class LightEditModeChangedEvent extends LightEvent {
  const LightEditModeChangedEvent({
    required this.editMode,
  });

  final bool editMode;

  @override
  List<Object?> get props => [editMode];
}
