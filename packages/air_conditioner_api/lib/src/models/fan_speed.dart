import 'package:json_annotation/json_annotation.dart';

enum FanSpeed {
  @JsonValue(0)
  quiet,
  @JsonValue(1)
  low,
  @JsonValue(2)
  medium,
  @JsonValue(3)
  high,
  @JsonValue(4)
  top,
  @JsonValue(5)
  auto,
}
