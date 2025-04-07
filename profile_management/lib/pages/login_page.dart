import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:profile_management/services/auth/auth_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final authService = AuthService();

  Future<String?> login(LoginData data) async {
    try {
      await authService.signInWithEmailPassword(data.name, data.password);
      return null;
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String?> signup(SignupData data) async {
    if (data.password == null || data.name == null) {
      return "Invalid email or password";
    }

    try {
      await authService.signUnWithEmailPassword(
        email: data.name!,
        password: data.password!,
      );
      return null;
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      await authService.resestPassword(email); // Fix typo
      return null;
    } catch (e) {
      return "Error: $e";
    }
  }

  LoginTheme themeLogin() {
    return LoginTheme(
      primaryColor: Colors.blue,
      accentColor: Colors.blue,
      errorColor: Colors.red,
      titleStyle: TextStyle(
        color: Colors.white,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 8,
        margin: EdgeInsets.all(16),
      ),
      inputTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.blue),
        ),
      ),
      buttonTheme: LoginButtonTheme(
        backgroundColor: Colors.blue,
        splashColor: Colors.white54,
        highlightColor: Colors.white70,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        theme: themeLogin(),
        onLogin: login,
        onSignup: signup,
        onRecoverPassword: resetPassword,
        messages: LoginMessages(
          userHint: "Enter your email",
          passwordHint: "Enter your password",
          confirmPasswordHint: "Confirm password",
          loginButton: "SIGN IN",
          signupButton: "REGISTER",
          forgotPasswordButton: "Forgot your password?",
        ),
        userValidator: (value) {
          if (value == null || value.isEmpty) return "Email required!";
          if (!value.contains("@") || !value.contains(".")) {
            return "Enter a valid email!";
          }
          return null;
        },
        passwordValidator: (value) {
          if (value == null || value.length < 6) {
            return "Password too short!";
          }
          return null;
        },
      ),
    );
  }
}
