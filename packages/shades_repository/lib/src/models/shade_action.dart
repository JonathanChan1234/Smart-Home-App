import 'package:json_annotation/json_annotation.dart';

part 'shade_action.g.dart';

@JsonSerializable()
class ShadeAction {
  const ShadeAction({
    this.actionType,
    this.level,
  });

  factory ShadeAction.fromJson(Map<String, dynamic> json) =>
      _$ShadeActionFromJson(json);

  final ShadeActionType? actionType;
  final int? level;

  Map<String, dynamic> toJson() => _$ShadeActionToJson(this);
}

enum ShadeActionType { raise, stop, lower }
