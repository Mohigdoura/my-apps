import 'package:auth_test/components/my_text_field.dart';
import 'package:auth_test/services/auth/auth_service.dart';
import 'package:auth_test/services/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  final void Function()? toggle;
  const LoginPage({super.key, required this.toggle});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorMessage;

  final authService = AuthService();
  bool obscureText = true;

  void toggleVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    void login() async {
      final auth = ref.read(authProvider.notifier);
      try {
        if (emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty) {
          final result = await auth.signIn(
            emailController.text,
            passwordController.text,
          );
          if (result != null) {
            if (mounted) {
              setState(() {
                errorMessage = 'Error';
              });
            }
          }
        } else {
          setState(() {
            errorMessage = 'Enter both email and password ';
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = '$e';
        });
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Login"), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Icon(Icons.person, size: 80),
              SizedBox(height: 50),
              MyTextField(
                controller: emailController,
                labelText: "Email",
                obscureText: false,
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 15),
              Stack(
                children: [
                  MyTextField(
                    controller: passwordController,
                    labelText: "Password",
                    obscureText: obscureText,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: toggleVisibility,
                      icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              GestureDetector(
                onTap: login,
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text("Login")),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("don't hava an account? "),
                  GestureDetector(
                    onTap: widget.toggle,
                    child: Text("Resgister now"),
                  ),
                ],
              ),
              SizedBox(height: 15),

              if (authState.isLoading) CircularProgressIndicator(),
              if (errorMessage != null)
                Text(errorMessage!, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}
