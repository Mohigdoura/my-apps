import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final bool obscureText;
  final TextInputType keyboardType;

  const MyTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey.shade700,
          ), // Default (unfocused)
          floatingLabelStyle: const TextStyle(
            color: Colors.blue,
          ), // When focused
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
