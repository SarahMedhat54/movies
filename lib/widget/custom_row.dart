import 'package:flutter/material.dart';

import '../core/app_assets.dart';
import '../core/app_colors.dart';

class CustomRow extends StatelessWidget {
  const CustomRow({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.black,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.yellow, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.lightBlack,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.yellow, width: 1),
            ),
            child: Image.asset(AppAssets.lr, height: 20, width: 20),
          ),
          const SizedBox(width: 10),
          Image.asset(AppAssets.eg, height: 20, width: 20),
          const SizedBox(width: 5),
        ],
      ),
    );
  }
}
