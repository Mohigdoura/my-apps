import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mdia/features/auth/domain/entities/app_user.dart';
import 'package:social_mdia/features/auth/presentation/cubits/auth_cupit.dart';
import 'package:social_mdia/features/profile/presentation/components/my_bio_box.dart';
import 'package:social_mdia/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_mdia/features/profile/presentation/cubit/profile_states.dart';
import 'package:social_mdia/features/profile/presentation/pages/edit_profile_page.dart';

class ProfilePage extends StatefulWidget {
  final String uid;
  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //cubits
  late final authCupit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  // current user
  late AppUser? currentUser = authCupit.currentUser;

  // on startup
  @override
  void initState() {
    super.initState();

    // load user profile data
    profileCubit.fetchUserProfile(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final user = state.profileUser;
          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
              centerTitle: true,
              foregroundColor: Theme.of(context).colorScheme.primary,
              actions: [
                IconButton(
                  onPressed:
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  EditProfilePage(user: state.profileUser),
                        ),
                      ),
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
            body: Column(
              children: [
                //email
                Text(
                  user.email,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 25),
                // profile pic
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  height: 120,
                  width: 120,
                  padding: EdgeInsets.all(25),
                  child: Icon(
                    Icons.person,
                    size: 72,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                MyBioBox(text: user.bio),

                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 25),
                  child: Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (state is ProfileLoading) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          return const Center(child: Text("No profile found.."));
        }
      },
    );
  }
}
