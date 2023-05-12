// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_bloc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeState _$HomeStateFromJson(Map<String, dynamic> json) => $checkedCreate(
      'HomeState',
      json,
      ($checkedConvert) {
        final val = HomeState(
          selectedHome: $checkedConvert(
              'selectedHome',
              (v) => v == null
                  ? null
                  : SmartHome.fromJson(v as Map<String, dynamic>)),
        );
        return val;
      },
    );

Map<String, dynamic> _$HomeStateToJson(HomeState instance) => <String, dynamic>{
      'selectedHome': instance.selectedHome?.toJson(),
    };
