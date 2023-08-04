import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'add_home_dto.g.dart';

@JsonSerializable()
class AddHomeDto extends Equatable {
  const AddHomeDto({
    required this.password,
  });

  factory AddHomeDto.fromJson(Map<String, dynamic> json) =>
      _$AddHomeDtoFromJson(json);

  final String password;

  Map<String, dynamic> toJson() => _$AddHomeDtoToJson(this);

  @override
  List<Object> get props => [password];
}
