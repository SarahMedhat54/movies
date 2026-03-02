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
  ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(AppString.forgetPassword, style: AppTextStyle.yello12W400),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.yellow),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 10),
              Center(
                child: Image.asset(
                  AppAssets.forgetPassword,
                  height: 200,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 12),
              CustomTextField(
                hintText: AppString.email,
                prefixIcon: AppAssets.email,
                controller: emailController,
              ),
              SizedBox(height: 40),
              CustomButton(
                text: AppString.verifyEmail,
                onPress: () async {
                  if (emailController.text.trim().isEmpty) {
                    showMessage(context, "Please enter your email", title: "Error", posText: "ok");
                    return;
                  }
                  try {
                    showLoading(context);
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: emailController.text.trim(),
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      showMessage(
                        context,
                        "Password reset link sent! Check your email.",
                        title: "Success",
                        posText: "ok",
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) Navigator.pop(context);
                      });
                    }
                  } on FirebaseAuthException catch (e) {
                    if (mounted) Navigator.pop(context);
                    showMessage(context, e.message ?? "Error", title: "Error", posText: "ok");
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
