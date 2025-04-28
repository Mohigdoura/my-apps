import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final int? maxLines;
  final int? maxLength;
  final String hintText;
  final TextInputType keyboardType;
  final Icon? icon;

  const MyTextField({
    super.key,
    required this.controller,
    this.labelText,
    this.maxLines = 1, // Default to 1 line
    this.hintText = '',
    this.maxLength,
    this.icon,
    this.keyboardType = TextInputType.text, // Default to text
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: maxLength,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: icon,
          labelText: labelText,
          labelStyle: TextStyle(color: Colors.grey.shade700),
          floatingLabelStyle: const TextStyle(color: Colors.blue),
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
