part of 'light_action_edit_cubit.dart';

class LightActionEditState extends Equatable {
  const LightActionEditState({
    this.brightness,
    this.colorTemperature,
  });

  final int? brightness;
  final int? colorTemperature;

  bool get isValid => brightness != null || colorTemperature != null;

  LightActionEditState copyWith({
    int? Function()? brightness,
    int? Function()? colorTemperature,
  }) {
    return LightActionEditState(
      brightness: brightness != null ? brightness() : this.brightness,
      colorTemperature:
          colorTemperature != null ? colorTemperature() : this.colorTemperature,
    );
  }

  @override
  List<Object?> get props => [
        brightness,
        colorTemperature,
      ];
}
