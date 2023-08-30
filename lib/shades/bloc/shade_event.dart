part of 'shade_bloc.dart';

abstract class ShadeEvent extends Equatable {
  const ShadeEvent();

  @override
  List<Object?> get props => [];
}

class ShadeMqttStatusSubscriptionRequestEvent extends ShadeEvent {
  const ShadeMqttStatusSubscriptionRequestEvent();
}

class ShadeProcessorStatusSubscriptionRequestEvent extends ShadeEvent {
  const ShadeProcessorStatusSubscriptionRequestEvent();
}

class ShadeStatusSubscriptionRequestedEvent extends ShadeEvent {
  const ShadeStatusSubscriptionRequestedEvent();
}

class ShadeListInitEvent extends ShadeEvent {
  const ShadeListInitEvent();
}

class ShadeControlEvent extends ShadeEvent {
  const ShadeControlEvent({
    required this.deviceId,
    required this.action,
  });

  final String deviceId;
  final ShadeAction action;

  @override
  List<Object?> get props => [deviceId, action];
}

class ShadeEditModeChangedEvent extends ShadeEvent {
  const ShadeEditModeChangedEvent({
    required this.editMode,
  });

  final bool editMode;

  @override
  List<Object?> get props => [editMode];
}
