import 'package:json_annotation/json_annotation.dart';

import 'device_action.dart';

part 'shade_action.g.dart';

@JsonSerializable()
class ShadeAction extends DeviceAction {
  const ShadeAction({
    this.actionType,
    this.level,
  }) : super();

  factory ShadeAction.fromJson(Map<String, dynamic> json) =>
      _$ShadeActionFromJson(json);

  final ShadeActionType? actionType;
  final int? level;

  @override
  Map<String, dynamic> toJson() => _$ShadeActionToJson(this);

  @override
  String toString() {
    final actions = <String>[];
    if (actionType != null) actions.add(actionType.toString().split('.')[1]);
    if (level != null) actions.add('Level: $level%');
    return actions.join(" | ");
  }
}

enum ShadeActionType {
  @JsonValue(0)
  raise,
  @JsonValue(1)
  lower,
  @JsonValue(2)
  na
}
