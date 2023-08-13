import 'package:json_annotation/json_annotation.dart';

part 'processor_status_dto.g.dart';

@JsonSerializable()
class ProcessorStatusDto {
  const ProcessorStatusDto({
    required this.lastUpdatedAt,
    required this.onlineStatus,
  });

  factory ProcessorStatusDto.fromJson(Map<String, dynamic> json) =>
      _$ProcessorStatusDtoFromJson(json);

  final String lastUpdatedAt;
  final bool onlineStatus;

  Map<String, dynamic> toJson() => _$ProcessorStatusDtoToJson(this);
}
