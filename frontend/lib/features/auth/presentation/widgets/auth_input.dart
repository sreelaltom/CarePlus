import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AuthInput extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? labelText;
  final Widget? suffixWidget;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onSubmit;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const AuthInput({
    super.key,
    required this.hintText,
    required this.controller,
    required this.focusNode,
    this.obscureText = false,
    this.suffixWidget,
    this.labelText,
    this.validator,
    this.onSubmit,
    this.keyboardType,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText ?? hintText,
        suffixIcon: suffixWidget,
      ),
      validator: validator,
      onFieldSubmitted: onSubmit,
      obscureText: obscureText,
    );
  }
}
