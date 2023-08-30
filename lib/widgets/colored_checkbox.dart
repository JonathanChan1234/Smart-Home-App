import 'package:flutter/material.dart';

class ColoredCheckbox extends StatelessWidget {
  const ColoredCheckbox({
    super.key,
    required this.onChanged,
    required this.value,
  });

  final void Function({bool? value}) onChanged;
  final bool value;

  Color getColor(Set<MaterialState> states) {
    const interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: value,
      onChanged: (value) => onChanged(value: value),
    );
  }
}
