import 'package:flutter/material.dart';
import 'package:move/core/app_colors.dart';
import 'package:move/core/app_string.dart';
import 'package:move/core/app_style.dart';
import 'package:move/data/onboarding_data.dart';
import 'package:move/widget/custom_button.dart';

import 'package:move/core/cache_helper.dart';

import '../main_Screen.dart'; // تأكد أن هذا المسار صحيح لديك

import 'package:move/screens/login/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController controller = PageController();
  int currentInt = 0;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    if (CacheHelper.isLoggedIn()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      });
    } else if (CacheHelper.isSkippedOnboarding()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) => setState(() => currentInt = index),
            itemBuilder: (context, index) {
              return Image.asset(
                onboardingData[index].image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.black.withOpacity(0.2),
                  AppColors.black.withOpacity(0.4),
                  AppColors.black.withOpacity(0.8),
                  AppColors.black,
                ],
                stops: const [0.0, 0.2, 0.7, 1.0],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              decoration: BoxDecoration(
                color: currentInt == 0 ? Colors.transparent : AppColors.black,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    onboardingData[currentInt].title,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.white18W500,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    onboardingData[currentInt].body,
                    style: AppTextStyle.white12normal,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: currentInt == 0
                              ? AppString.exploreNow
                              : (currentInt == onboardingData.length - 1
                                    ? AppString.finish
                                    : AppString.next),
                          onPress: () {
                            if (currentInt < onboardingData.length - 1) {
                              controller.nextPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            } else {
                              CacheHelper.skipOnboarding();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  //  builder: (context) => const MainScreen(),
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  if (currentInt > 0) ...[
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            text: AppString.back,
                            backgroundColor: Colors.transparent,
                            border: const BorderSide(color: AppColors.yellow),
                            textStyle: AppTextStyle.yello14W400,
                            onPress: () {
                              controller.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
