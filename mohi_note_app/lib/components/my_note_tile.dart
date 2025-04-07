import 'package:flutter/material.dart';

class MyNoteTile extends StatelessWidget {
  void Function()? onTap;
  final String text;
  void Function()? onLongPress;
  MyNoteTile({
    super.key,
    required this.onTap,
    required this.text,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade500,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Center(child: Text(text)),
            ),
          ],
        ),
      ),
    );
  }
}
