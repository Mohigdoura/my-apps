import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final FocusNode? focusNode; // Focus node for the text field
  final bool obsecureText; // Set to true for password field
  final TextEditingController controller;
  final void Function(String)? onSubmitted;
  const MyTextField({
    super.key,
    required this.hintText,
    required this.obsecureText,
    required this.controller,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onSubmitted: onSubmitted,
      maxLength: 500,
      textAlignVertical: TextAlignVertical.center,
      focusNode: focusNode,
      controller: controller,
      obscureText: obsecureText, // Set to true for password field
      decoration: InputDecoration(
        hintMaxLines: 2,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.tertiary),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
        ),
        hintText: hintText,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,
      ),
    );
  }
}
