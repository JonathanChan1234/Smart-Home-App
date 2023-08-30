import 'package:json_annotation/json_annotation.dart';

part 'error_body.g.dart';

@JsonSerializable()
class ErrorBody {
  const ErrorBody({
    required this.message,
  });

  factory ErrorBody.fromJson(Map<String, dynamic> json) =>
      _$ErrorBodyFromJson(json);

  final String message;

  Map<String, dynamic> toJson() => _$ErrorBodyToJson(this);
}
