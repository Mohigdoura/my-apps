import 'package:auth_test/components/my_text_field.dart';
import 'package:auth_test/services/auth/auth_service.dart';
import 'package:auth_test/services/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterPage extends ConsumerStatefulWidget {
  final void Function()? toggle;
  const RegisterPage({super.key, required this.toggle});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final authService = AuthService();
  String? errorMessage = '';

  bool obscureText = true;

  void toggleVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    void register() async {
      final auth = ref.read(authProvider.notifier);
      try {
        if (emailController.text.isNotEmpty &&
            passwordController.text.isNotEmpty &&
            nameController.text.isNotEmpty) {
          if (passwordController.text == confirmPasswordController.text) {
            final result = await auth.signUp(
              emailController.text,
              passwordController.text,
              nameController.text,
            );
            if (result != null) {
              if (mounted) {
                setState(() {
                  errorMessage = 'error';
                });
              }
            }

            emailController.dispose();
            passwordController.dispose();
            confirmPasswordController.dispose();
            nameController.dispose();
          }
          setState(() {
            if (mounted) {
              errorMessage = 'Passwords should be the same';
            }
          });
        } else {
          setState(() {
            errorMessage = 'Enter name, email and password ';
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            errorMessage = 'Error:$e';
          });
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Register"), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Icon(Icons.person, size: 80),
              SizedBox(height: 50),
              MyTextField(
                controller: nameController,
                labelText: "Name",
                obscureText: false,
              ),
              SizedBox(height: 15),
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
              Stack(
                children: [
                  MyTextField(
                    controller: confirmPasswordController,
                    labelText: "Confirm password",
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
                onTap: register,
                child: Container(
                  padding: EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(child: Text("Register")),
                ),
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already hava an account? "),
                  GestureDetector(
                    onTap: widget.toggle,
                    child: Text("Login now"),
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
