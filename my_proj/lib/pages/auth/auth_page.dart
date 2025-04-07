import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:my_proj/services/auth_service.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // Create instance of your auth service
  final AuthService authService = AuthService();

  // Selected role for signup
  final String selectedRole = 'customer'; // Default role

  Future<String?> login(LoginData data) async {
    try {
      // Fixed the missing authService call
      await authService.signInWithEmailPassword(
        email: data.name,
        password: data.password,
      );
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
      // Pass the selected role to signup function
      await authService.signUpWithEmailPassword(
        email: data.name!,
        password: data.password!,
        role: selectedRole, // Pass the role
      );
      return null;
    } catch (e) {
      return "Error: $e";
    }
  }

  Future<String?> resetPassword(String email) async {
    try {
      // Fixed typo in resetPassword
      await authService.resestPassword(email);
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
        additionalSignupFields: [
          UserFormField(
            keyName: 'role',
            displayName: 'Account Type',
            icon: Icon(Icons.person),
            fieldValidator: (value) => null,

            userType: LoginUserType.name,
            defaultValue: 'customer',
          ),
        ],
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
