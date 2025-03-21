import 'package:flutter/material.dart';
import 'package:to_do/components/drawer_tile.dart';
import 'package:to_do/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.background,
      child: Column(
        children: [
          SizedBox(height: 200, child: Icon(Icons.note)),
          // note tile
          DrawerTile(
            title: "Notes",
            leading: Icon(Icons.home),
            onTap: () => Navigator.pop(context),
          ),

          // settings tile
          DrawerTile(
            title: "Settings",
            leading: Icon(Icons.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
