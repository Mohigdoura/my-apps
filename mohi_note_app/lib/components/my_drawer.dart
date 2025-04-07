import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Icon(Icons.edit, size: 45, color: Colors.white),
          ),
          ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 10),
                child: ListTile(
                  onTap: () => Navigator.pop(context),
                  leading: Icon(Icons.home),
                  title: Text('HomePage'),
                  autofocus: true,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, top: 10),
                child: ListTile(
                  onTap: () {},
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  autofocus: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
