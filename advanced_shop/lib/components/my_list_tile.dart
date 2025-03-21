import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyListTile extends StatelessWidget {
  final String text;
  final IconData icon;
  void Function()? onTap;
  MyListTile({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: Colors.grey),
        title: Text(text),
      ),
    );
  }
}
