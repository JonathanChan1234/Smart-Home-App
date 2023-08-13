import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'processor.g.dart';

@JsonSerializable()
class Processor extends Equatable {
  const Processor({
    required this.id,
    required this.onlineStatus,
    required this.mqttClientId,
  });

  factory Processor.fromJson(Map<String, dynamic> json) =>
      _$ProcessorFromJson(json);

  final String id;
  final int mqttClientId;
  final bool onlineStatus;

  Map<String, dynamic> toJson() => _$ProcessorToJson(this);

  @override
  List<Object> get props => [
        id,
        mqttClientId,
        onlineStatus,
      ];
}
