part of 'air_conditioner_bloc.dart';

abstract class AirConditionerEvent extends Equatable {
  const AirConditionerEvent();

  @override
  List<Object?> get props => [];
}

class AirConditionerListInitEvent extends AirConditionerEvent {
  const AirConditionerListInitEvent();
}

class AirConditionerStatusSubscriptionRequestEvent extends AirConditionerEvent {
  const AirConditionerStatusSubscriptionRequestEvent();
}

class AirConditionerMqttStatusSubscriptionRequestEvent
    extends AirConditionerEvent {
  const AirConditionerMqttStatusSubscriptionRequestEvent();
}

class AirConditionerProcessorStatusSubscriptionRequestEvent
    extends AirConditionerEvent {
  const AirConditionerProcessorStatusSubscriptionRequestEvent();
}

class AirConditionerStatusChangedEvent extends AirConditionerEvent {
  const AirConditionerStatusChangedEvent({
    required this.deviceId,
    required this.properties,
  });

  final String deviceId;
  final AirConditionerProperties properties;

  @override
  List<Object?> get props => [deviceId, properties];
}

class AirConditionerEditModeChangedEvent extends AirConditionerEvent {
  const AirConditionerEditModeChangedEvent({
    required this.editMode,
  });

  final bool editMode;

  @override
  List<Object?> get props => [editMode];
}
