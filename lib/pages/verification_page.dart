import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suders/utils/app_colors.dart';
import 'package:suders/utils/app_text_styles.dart';
import 'package:suders/utils/app_paddings.dart';
//for the demo, we made the verification code  "111111" this is only for the demo and not the final form of verification page
class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (_) => FocusNode(),
  );
  
  static const String _demoCode = '111111';

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyCode() {
    final enteredCode = _controllers.map((c) => c.text).join();
    
    if (enteredCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter all 6 digits"),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }

    if (enteredCode == _demoCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Verification successful!"),
          backgroundColor: AppColors.success,
        ),
      );
      // Navigate to welcome back page after a short delay
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/welcomeBack');
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Invalid verification code. Please try again."),
          backgroundColor: AppColors.danger,
        ),
      );
      // Clear all fields
      for (var controller in _controllers) {
        controller.clear();
      }
      // Focus on first field
      _focusNodes[0].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textMain),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: AppPaddings.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "Enter Verification Code",
              style: AppTextStyles.title,
            ),
            const SizedBox(height: 12),
            Text(
              "Enter the code sent to your\nSabancı University email.",
              textAlign: TextAlign.center,
              style: AppTextStyles.body.copyWith(height: 1.5),
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  height: 60,
                  child: TextFormField(
                    controller: _controllers[index],
                    focusNode: _focusNodes[index],
                    onChanged: (value) {
                      if (value.length == 1 && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textMain,
                    ),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.primary),
                      ),
                      filled: true,
                      fillColor: AppColors.card,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't get a code? ",
                  style: AppTextStyles.body,
                ),
                GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Code resent! Check your email."),
                      ),
                    );
                  },
                  child: Text(
                    "Resend",
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, '/welcomeBack');
              },
              child: Text(
                "Log In",
                style: AppTextStyles.body.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _verifyCode,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Verify",
                  style: AppTextStyles.body.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
