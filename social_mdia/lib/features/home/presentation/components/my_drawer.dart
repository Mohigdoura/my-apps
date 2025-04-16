import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mdia/features/auth/presentation/cubits/auth_cupit.dart';
import 'package:social_mdia/features/home/presentation/components/my_drawer_tile.dart';
import 'package:social_mdia/features/profile/presentation/pages/profile_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              // logo
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 50.0),
                child: Icon(
                  Icons.person,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Divider(color: Theme.of(context).colorScheme.secondary),
              // home tile
              MyDrawerTile(
                title: "Home",
                icon: Icons.home,
                onTap: () => Navigator.pop(context),
              ),

              // profile tile
              MyDrawerTile(
                title: "Profile",
                icon: Icons.person,
                onTap: () {
                  // pop menu drawer
                  Navigator.pop(context);

                  // get current user id
                  final user = context.read<AuthCubit>().currentUser;
                  String? uid = user!.uid;
                  // navigate to profile page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(uid: uid),
                    ),
                  );
                },
              ),

              // search tile
              MyDrawerTile(title: "Search", icon: Icons.search, onTap: () {}),

              // settings tile
              MyDrawerTile(
                title: "Settings",
                icon: Icons.settings,
                onTap: () {},
              ),
              Spacer(),
              // logout tile
              MyDrawerTile(
                title: "Logout",
                icon: Icons.logout,
                onTap: () => context.read<AuthCubit>().logout(),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
