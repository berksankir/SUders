import 'package:flutter/material.dart';
import 'package:suders/utils/app_colors.dart';
import 'package:suders/utils/app_text_styles.dart';
import 'package:suders/utils/app_paddings.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppPaddings.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.cardAlt,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.school,
                    size: 32,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  "Join the SU Community",
                  style: AppTextStyles.title,
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  "For Sabancı University students only.",
                  style: AppTextStyles.body,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "Full Name",
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                style: TextStyle(color: AppColors.textMain),
                decoration: InputDecoration(
                  hintText: "Enter your full name",
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.card,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "SU Email",
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: TextFormField(
                      style: TextStyle(color: AppColors.textMain),
                      decoration: InputDecoration(
                        hintText: "yourusername",
                        hintStyle: TextStyle(color: AppColors.textMuted),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          borderSide: BorderSide(color: AppColors.primary),
                        ),
                        filled: true,
                        fillColor: AppColors.card,
                      ),
                    ),
                  ),
                  Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.cardAlt,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Text(
                      "@sabanciuniv.edu",
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                "Password",
                style: AppTextStyles.sectionTitle,
              ),
              const SizedBox(height: 8),
              TextFormField(
                obscureText: !_isPasswordVisible,
                style: TextStyle(color: AppColors.textMain),
                decoration: InputDecoration(
                  hintText: "Create a secure password",
                  hintStyle: TextStyle(color: AppColors.textMuted),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/verification');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Create Account",
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/welcomeBack');
                  },
                  child: RichText(
                    text: TextSpan(
                      text: "Already have an account? ",
                      style: TextStyle(color: AppColors.textSecondary),
                      children: [
                        TextSpan(
                          text: "Log In",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
