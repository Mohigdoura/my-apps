import 'package:auth_test/pages/auth/login_page.dart';
import 'package:auth_test/pages/auth/register_page.dart';
import 'package:flutter/material.dart';

class LoginRegisterPage extends StatefulWidget {
  const LoginRegisterPage({super.key});

  @override
  State<LoginRegisterPage> createState() => _LoginRegisterPageState();
}

class _LoginRegisterPageState extends State<LoginRegisterPage> {
  bool isLogin = true;
  void toggle() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return LoginPage(toggle: toggle);
    } else {
      return RegisterPage(toggle: toggle);
    }
  }
}
