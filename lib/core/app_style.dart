import 'package:flutter/material.dart';

import 'app_colors.dart';
abstract final class AppTextStyle {
  static const TextStyle white12normal = TextStyle(fontSize: 12, color: AppColors.white, fontWeight: FontWeight.normal);
  static const TextStyle white18W500 = TextStyle(fontSize:18, color: AppColors.white, fontWeight: FontWeight.w500);
  static const TextStyle yello14W400 = TextStyle(fontSize: 14, color: AppColors.yellow, fontWeight: FontWeight.w400);
  static const TextStyle black14W400 = TextStyle(fontSize: 14, color: AppColors.black, fontWeight: FontWeight.w400);
  static const TextStyle black14W600 = TextStyle(fontSize: 14, color: AppColors.black, fontWeight: FontWeight.w600);
  static const TextStyle yello12W400 = TextStyle(fontSize: 12, color: AppColors.yellow, fontWeight: FontWeight.w400);
}