import 'package:flutter/material.dart';

import '../core/app_colors.dart';
import '../core/app_string.dart';
import '../core/app_style.dart';

class CustomOrDesign extends StatelessWidget {
  const CustomOrDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return  Row(
      children: [
        Expanded(child: Divider(color: AppColors.yellow)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Text(AppString.or, style: AppTextStyle.yello12W400),
        ),
        Expanded(child: Divider(color: AppColors.yellow)),
      ],
    );
  }
}
