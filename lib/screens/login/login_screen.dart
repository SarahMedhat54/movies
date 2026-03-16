import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:move/core/app_assets.dart';
import 'package:move/core/app_colors.dart';
import 'package:move/core/app_string.dart';
import 'package:move/core/app_style.dart';
import 'package:move/widget/custom_button.dart';
import 'package:move/widget/custom_or_design.dart';
import 'package:move/widget/custom_row.dart';
import 'package:move/widget/custom_text_field.dart';
import 'package:move/screens/home/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/app_dialogs.dart';
import '../../core/app_route.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 60),
              Image.asset(AppAssets.logo, height: 100, width: 100),
              const SizedBox(height: 30),
              CustomTextField(
                hintText: AppString.email,
                prefixIcon: AppAssets.email,
                controller: emailController,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                hintText: AppString.password,
                prefixIcon: AppAssets.lock,
                controller: passwordController,
                isPassword: isObscure,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => isObscure = !isObscure),
                  icon: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(context, AppRoutes.forgetPassword);
                  },
                  child: const Text(
                    AppString.forgetPasswordQue,
                    style: AppTextStyle.yello12W400,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              CustomButton(
                text: AppString.login,
                onPress: () async {
                  if (emailController.text.isEmpty || passwordController.text.isEmpty) {
                    showMessage(context, "Please enter your email and password", title: "Required", posText: "OK");
                    return;
                  }
                  //
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.setBool('isLoggedIn', true);
                  // معدلاه عشان اتخطي الفيربيز موقتا
                  if (mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const HomeScreen()),
                    );
                  }
                },
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(AppString.haveAccount, style: AppTextStyle.white12normal),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, AppRoutes.register);
                    },
                    child: const Text(AppString.createOne, style: AppTextStyle.yello12W400),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const CustomOrDesign(),
              const SizedBox(height: 20),
              CustomButton(
                text: AppString.loginWithGoogle,
                onPress: () async {
                  try {
                    showLoading(context);
                    final user = await signInWithGoogle();

                    if (mounted) Navigator.pop(context);
                    if (user != null) {
                      if (mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const HomeScreen()),
                        );
                      }
                    }
                  } catch (e) {
                    if (mounted) Navigator.pop(context);
                    showMessage(context, "Google Sign-In failed. Please try again.", title: "Error", posText: "OK");
                  }
                },
                icon: SvgPicture.asset(AppAssets.iconGoogle, height: 30),
              ),
              const SizedBox(height: 30),
              const CustomRow(),
            ],
          ),
        ),
      ),
    );
  }
}