import 'package:auth_test/services/auth/auth_service.dart';
import 'package:auth_test/services/provider/auth_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for haptic feedback
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RegisterPage extends ConsumerStatefulWidget {
  final void Function()? toggle;
  const RegisterPage({super.key, required this.toggle});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final authService = AuthService();
  String? errorMessage;
  bool obscureText = true;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    // Create shake animation
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.05, 0.0),
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticIn),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.reverse();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void toggleVisibility() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  // Method to show error with haptic feedback and animation
  void showErrorWithFeedback(String message) {
    // Vibrate phone
    HapticFeedback.heavyImpact();

    // Set error message
    setState(() {
      errorMessage = message;
    });

    // Play shake animation
    _animationController.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    Future<void> register() async {
      // Hide keyboard
      FocusScope.of(context).unfocus();

      // Reset error message
      setState(() {
        errorMessage = null;
      });

      final auth = ref.read(authProvider.notifier);
      try {
        // Validate inputs
        if (emailController.text.isEmpty ||
            passwordController.text.isEmpty ||
            nameController.text.isEmpty ||
            phoneController.text.isEmpty) {
          showErrorWithFeedback(loc.enter_name_email_password);
          return;
        }

        // Validate passwords match
        if (passwordController.text != confirmPasswordController.text) {
          showErrorWithFeedback(loc.passwords_should_be_same);
          return;
        }
        int? phoneNumber = int.tryParse(phoneController.text);

        // Validate phone
        if (phoneController.text.length != 8 || phoneNumber == null) {
          showErrorWithFeedback("invalid phone number");
          return;
        }

        // Attempt registration
        final result = await auth.signUp(
          emailController.text.trim(),
          passwordController.text.trim(),
          nameController.text.trim(),
          phoneNumber,
        );

        if (result != null && mounted) {
          showErrorWithFeedback('${loc.error}: $result');
        }
      } catch (e) {
        if (mounted) {
          showErrorWithFeedback('${loc.error}: $e');
        }
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              SizedBox(height: 25),
              // Custom app bar
              Text(
                loc.register,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              // Registration form
              Expanded(
                child: ListView(
                  children: [
                    const SizedBox(height: 20),
                    // Avatar/icon
                    Center(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: theme.primaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.person_add_rounded,
                          size: 50, // Smaller icon
                          color: theme.primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Name field
                    _buildTextField(
                      controller: nameController,
                      label: loc.name,
                      prefixIcon: Icons.person_outline,
                    ),
                    const SizedBox(height: 10),

                    // phone field
                    _buildTextField(
                      controller: phoneController,
                      label: "Phone number",
                      prefixIcon: Icons.phone,
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),

                    // Email field
                    _buildTextField(
                      controller: emailController,
                      label: loc.email,
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 10),

                    // Password field
                    _buildTextField(
                      controller: passwordController,
                      label: loc.password,
                      prefixIcon: Icons.lock_outline,
                      obscureText: obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: toggleVisibility,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 10),

                    // Confirm password field
                    _buildTextField(
                      controller: confirmPasswordController,
                      label: loc.confirm_password,
                      prefixIcon: Icons.lock_outline,
                      obscureText: obscureText,
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: toggleVisibility,
                      ),
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(height: 20),

                    // Register button
                    SizedBox(
                      width: double.infinity,
                      height: 50, // Slightly smaller button
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child:
                            authState.isLoading
                                ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                                : Text(
                                  loc.register,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),

              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(loc.already_have_account),
                  TextButton(
                    onPressed: widget.toggle,
                    style: TextButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    ),
                    child: Text(
                      loc.login_now,
                      style: TextStyle(
                        color: theme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              // Animated error message
              if (errorMessage != null)
                SlideTransition(
                  position: _offsetAnimation,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10, top: 5),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.red.shade300,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(height: 10), // Add space at bottom
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(prefixIcon, color: Colors.grey),
          suffixIcon: suffixIcon,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
          ), // Slightly smaller padding
        ),
      ),
    );
  }
}
