import 'package:flutter/material.dart';
import 'package:popover/popover.dart';
import 'package:to_do/components/note_settings.dart';

class NoteTile extends StatelessWidget {
  final String text;
  final void Function()? onEditPressed;
  final void Function()? onDeletePressed;
  NoteTile({
    super.key,
    required this.text,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: EdgeInsets.only(top: 10, left: 25, right: 25),
      child: ListTile(
        title: Text(
          text,
          style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        ),
        trailing: Builder(
          builder: (context) {
            return IconButton(
              onPressed:
                  () => showPopover(
                    width: 100,
                    height: 100,
                    context: context,
                    backgroundColor: Theme.of(context).colorScheme.background,
                    bodyBuilder:
                        (context) => NoteSettings(
                          onDeleteTap: onDeletePressed,
                          onEditTap: onEditPressed,
                        ),
                  ),
              icon: Icon(Icons.more_vert),
            );
          },
        ),
      ),
    );
  }
}
