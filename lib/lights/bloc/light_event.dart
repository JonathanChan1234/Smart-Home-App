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
    required this.properties,
  });

  final String deviceId;
  final LightProperties properties;

  @override
  List<Object?> get props => [deviceId, properties];
}

class LightEditModeChangedEvent extends LightEvent {
  const LightEditModeChangedEvent({
    required this.editMode,
  });

  final bool editMode;

  @override
  List<Object?> get props => [editMode];
}
