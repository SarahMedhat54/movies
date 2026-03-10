import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move/core/app_assets.dart';
import 'package:move/core/app_colors.dart';
import 'package:move/core/app_string.dart';
import 'package:move/core/app_style.dart';
import 'package:move/widget/custom_button.dart';
import 'package:move/widget/custom_text_field.dart';
import '../../core/app_dialogs.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(AppString.forgetPassword, style: AppTextStyle.yello12W400),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
              Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.yellow),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 30),
              Center(
                child: Image.asset(
                  AppAssets.forgetPassword,
                  height: 280,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                hintText: AppString.email,
                prefixIcon: AppAssets.email,
                controller: emailController,
              ),
              const SizedBox(height: 30),
              CustomButton(
                text: AppString.verifyEmail,
                onPress: () async {
                  final email = emailController.text.trim();
                  if (email.isEmpty) {
                    showMessage(context, "Please enter your email address",
                        title: "Required", posText: "OK");
                    return;
                  }
                  try {
                    showLoading(context);
                    await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
                    if (mounted) {
                      Navigator.pop(context);
                      showMessage(
                        context,
                        "A reset link has been sent to $email. Please check your inbox or spam folder.",
                        title: "Success",
                        posText: "OK",
                      );
                      Future.delayed(const Duration(seconds: 3), () {
                        if (mounted && Navigator.canPop(context)) {
                          Navigator.pop(context);
                        }
                      });
                    }
                  } on FirebaseAuthException catch (e) {
                    if (mounted) Navigator.pop(context); // إغلاق الـ Loading

                    String errorMessage = "An error occurred";
                    if (e.code == 'user-not-found') {
                      errorMessage = "This email is not registered. Please create an account first.";
                    } else if (e.code == 'invalid-email') {
                      errorMessage = "The email address is not valid.";
                    } else {
                      errorMessage = e.message ?? "Something went wrong";
                    }

                    showMessage(context, errorMessage, title: "Error", posText: "OK");
                  } catch (e) {
                    if (mounted) Navigator.pop(context);
                    showMessage(context, "Unexpected error occurred", title: "Error", posText: "OK");
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}