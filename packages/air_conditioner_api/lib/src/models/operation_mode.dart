import 'package:json_annotation/json_annotation.dart';

enum OperationMode {
  @JsonValue(0)
  fan,
  @JsonValue(1)
  heat,
  @JsonValue(2)
  cool,
  @JsonValue(3)
  dry,
  @JsonValue(4)
  auto,
}
