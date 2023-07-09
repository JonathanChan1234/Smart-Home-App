// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shade_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShadeAction _$ShadeActionFromJson(Map<String, dynamic> json) => $checkedCreate(
      'ShadeAction',
      json,
      ($checkedConvert) {
        final val = ShadeAction(
          actionType: $checkedConvert('actionType',
              (v) => $enumDecodeNullable(_$ShadeActionTypeEnumMap, v)),
          level: $checkedConvert('level', (v) => v as int?),
        );
        return val;
      },
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
