import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.onChanged,
    required this.errorText,
    required this.labelText,
    this.passwordField = false,
  });

  final void Function(String) onChanged;
  final String? errorText;
  final String labelText;
  final bool passwordField;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: passwordField,
      enableSuggestions: passwordField,
      autocorrect: passwordField,
      decoration: InputDecoration(
        labelText: labelText,
        errorText: errorText,
        labelStyle: const TextStyle(color: Colors.black),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade300),
        ),
      ),
    );
  }
}
