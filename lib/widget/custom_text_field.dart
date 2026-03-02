import 'package:flutter/material.dart';
import 'package:move/core/app_colors.dart';
import 'package:move/core/app_style.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;

  final IconData prefixIcon;

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
        prefixIcon: Icon(prefixIcon, color:  AppColors.white, size: 20,),
        suffixIcon: suffixIcon ,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
      ),

    ) ;
  }
}
