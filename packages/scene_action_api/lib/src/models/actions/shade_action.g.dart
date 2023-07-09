// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shade_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShadeAction _$ShadeActionFromJson(Map<String, dynamic> json) => ShadeAction(
      actionType:
          $enumDecodeNullable(_$ShadeActionTypeEnumMap, json['actionType']),
      level: json['level'] as int?,
    );

Map<String, dynamic> _$ShadeActionToJson(ShadeAction instance) =>
    <String, dynamic>{
      'actionType': _$ShadeActionTypeEnumMap[instance.actionType],
      'level': instance.level,
    };

const _$ShadeActionTypeEnumMap = {
  ShadeActionType.raise: 'raise',
  ShadeActionType.stop: 'stop',
  ShadeActionType.lower: 'lower',
};
