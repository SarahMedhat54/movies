import 'package:flutter/material.dart';
import 'package:move/core/app_colors.dart';
import 'package:move/core/app_style.dart';

class CustomButton extends StatelessWidget {
  final String text;

  final Color? backgroundColor;

  final TextStyle? textStyle;

  final BorderSide? border;

  final VoidCallback onPress;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPress,
    this.backgroundColor,
    this.textStyle,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppColors.yellow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: border ?? BorderSide.none,
        elevation: 0,
      ),
      onPressed: onPress,
      child: Text(text, style: textStyle??AppTextStyle.black14W600),
    );
  }
}
