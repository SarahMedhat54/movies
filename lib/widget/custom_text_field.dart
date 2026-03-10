import 'package:flutter/material.dart';
import 'package:move/core/app_colors.dart';
import 'package:move/core/app_style.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  // 1. غيرنا النوع هنا لـ String عشان ياخد مسار الصورة
  final String prefixIcon;
  final Widget? suffixIcon;
  final bool isPassword;
  final TextEditingController? controller;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: AppTextStyle.white12normal,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyle.white12normal,
        filled: true,
        fillColor: AppColors.lightBlack,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            prefixIcon,
            height: 20,
            width: 20,
            color: AppColors.white,
          ),
        ),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.yellow, width: 1),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}