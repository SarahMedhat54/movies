import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:move/core/app_assets.dart';
import 'package:move/core/app_colors.dart';
import 'package:move/core/app_string.dart';
import 'package:move/core/app_style.dart';
import 'package:move/widget/custom_button.dart';
import 'package:move/widget/custom_text_field.dart';
import '../../core/app_dialogs.dart';
import '../../firebase/firebase_store.dart';
import '../../model/user_data.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscure = true;

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
        padding:  EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
               SizedBox(height: 60),
              Image.asset(AppAssets.logo, height: 100, width: 100),
               SizedBox(height: 30),
              CustomTextField(
                hintText: AppString.email,
                prefixIcon:AppAssets.email,
                controller: emailController,
              ),
               SizedBox(height: 12),
              CustomTextField(
                hintText: AppString.password,
                prefixIcon: AppAssets.lock,
                controller: passwordController,
                isPassword: isObscure,
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isObscure = !isObscure;
                    });
                  },
                  icon: Icon(
                    isObscure ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.white,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child:  Text(
                    AppString.forgetPassword,
                    style: AppTextStyle.yello12W400,
                  ),
                ),
              ),
               SizedBox(height: 6),
              CustomButton(
                text: AppString.login,
                onPress: () async {
                  showLoading(context);
                  try {
                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: emailController.text.trim(),
                      password: passwordController.text,
                    );
                    UserData.currentUser = await getUserFromFirestore(credential.user!.uid);

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  } on FirebaseAuthException catch (e) {
                    if (mounted) Navigator.pop(context);
                    String message = e.code == 'user-not-found'
                        ? 'No user found for that email.'
                        : (e.code == 'wrong-password' ? 'Wrong password.' : e.message ?? "Error");
                    showMessage(context, message, title: "Error", posText: "ok");
                  } catch (e) {
                    if (mounted) Navigator.pop(context);
                    showMessage(context, AppString.defaultErrorMessage, title: "Error", posText: "ok");
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
                    },
                    child: const Text(AppString.createOne, style: AppTextStyle.yello12W400),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  Expanded(child: Divider(color: AppColors.yellow)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(AppString.or, style: AppTextStyle.yello12W400),
                  ),
                  Expanded(child: Divider(color: AppColors.yellow)),
                ],
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: AppString.loginWithGoogle,
                onPress: () async {
                  showLoading(context);
                  try {
                    var userCredential = await signInWithGoogle();
                    if (userCredential != null) {
                    }
                    if (mounted) Navigator.pop(context);
                  } catch (e) {
                    if (mounted) Navigator.pop(context);
                  }
                },
                icon: SvgPicture.asset(AppAssets.iconGoogle, height: 30),
              ),
              SizedBox(height: 30),
              Container(
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}