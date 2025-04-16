import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_mdia/features/auth/data/firebase_auth_repo.dart';
import 'package:social_mdia/features/auth/presentation/cubits/auth_cupit.dart';
import 'package:social_mdia/features/auth/presentation/cubits/auth_states.dart';
import 'package:social_mdia/features/auth/presentation/pages/auth_page.dart';
import 'package:social_mdia/features/home/presentation/pages/home_page.dart';
import 'package:social_mdia/config/firebase_options.dart';
import 'package:social_mdia/features/profile/data/firebase_profile_repo.dart';
import 'package:social_mdia/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:social_mdia/themes/light_mode.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

/* app - root level

repositories: for the database
-firebase

bloc providers: for state management
-auth 
-profile
-post
-search
-theme
check auth state
  -unauthenticated -> auth page
  -authenticated -> home page
*/
class MyApp extends StatelessWidget {
  // auth repo
  final authRepo = FirebaseAuthRepo();

  // profile repo
  final profileRepo = FirebaseProfileRepo();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // auth cubit
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(authRepo: authRepo)..checkAuth(),
        ),
        // profile cubit
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(profileRepo: profileRepo),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: lightMode,
        home: BlocConsumer<AuthCubit, AuthStates>(
          builder: (context, authState) {
            print(authState);
            if (authState is Unauthenticated) {
              return const AuthPage();
            }

            if (authState is Authenticated) {
              return const HomePage();
            } else {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
          },
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
        ),
      ),
    );
  }
}
