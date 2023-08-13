import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.onChanged,
    required this.errorText,
    required this.labelText,
    this.initialValue = '',
    this.passwordField = false,
    this.numberOnly = false,
    this.enabled = true,
  });

  final void Function(String) onChanged;
  final String? errorText;
  final String labelText;
  final String initialValue;
  final bool passwordField;
  final bool numberOnly;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      onChanged: onChanged,
      obscureText: passwordField,
      enableSuggestions: passwordField,
      autocorrect: passwordField,
      enabled: enabled,
      keyboardType: numberOnly ? TextInputType.number : null,
      inputFormatters: numberOnly
          ? <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly]
          : null,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        errorMaxLines: 5,
        labelStyle: const TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
      ),
    );
  }
}
