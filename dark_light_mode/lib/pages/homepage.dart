import 'package:dark_light_mode/components/box.dart';
import 'package:dark_light_mode/components/button.dart';
import 'package:dark_light_mode/riverpod_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: MyBox(
          color: Theme.of(context).colorScheme.primary,
          child: MyButton(
            color: Theme.of(context).colorScheme.secondary,
            onTap: () {
              ref.read(riverpopTheme.notifier).toggleTheme();
            },
          ),
        ),
      ),
    );
  }
}
