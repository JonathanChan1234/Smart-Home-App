import 'package:json_annotation/json_annotation.dart';

part 'error_message.g.dart';

@JsonSerializable()
class ErrorMessage {
  const ErrorMessage({
    required this.message,
  });

  final String message;

  Map<String, dynamic> toJson() => _$ErrorMessageToJson(this);

  factory ErrorMessage.fromJson(Map<String, dynamic> json) =>
      _$ErrorMessageFromJson(json);
}
