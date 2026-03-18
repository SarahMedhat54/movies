import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move/core/app_assets.dart';
import 'package:move/core/app_colors.dart';
import 'package:move/core/app_string.dart';
import 'package:move/core/app_style.dart';
import 'package:move/widget/custom_button.dart';
import 'package:move/widget/custom_row.dart';
import 'package:move/widget/custom_text_field.dart';

import '../../core/app_dialogs.dart';
import '../../firebase/firebase_store.dart';
import '../../model/user_data.dart';
import '../home/home_screen.dart';
import '../main_Screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  bool isObscurePassword = true;
  bool isObscureConfirm = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  final List<String> avatars = [
   AppAssets.avatar1,
    AppAssets.avatar2 ,
    AppAssets.avatar3,
    AppAssets.avatar4 ,
    AppAssets.avatar5 ,
    AppAssets.avatar6,
    AppAssets.avatar7,
    AppAssets.avatar8,
  ];
  String selectedAvatar = AppAssets.avatar1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(onPressed:()=> Navigator.pop(context), icon: Icon(Icons.arrow_back_ios_new,color: AppColors.yellow,)),
        title: Text(AppString.register ,style: AppTextStyle.yello12W400,),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CarouselSlider(
                items: avatars.map((assetPath) {
                  return Image.asset(assetPath, fit: BoxFit.contain);
                }).toList(),
                options: CarouselOptions(
                  height: 140,
                  enlargeCenterPage: true,
                  enableInfiniteScroll: false,
                  viewportFraction: 0.35,
                  onPageChanged: (index, reason) {
                    setState(() {
                      selectedAvatar = avatars[index];
                    });
                  },
                ),
              ),
              Text(AppString.avatar, style: AppTextStyle.white12normal,),
              SizedBox(height: 10,),
              CustomTextField(hintText: AppString.name, prefixIcon: AppAssets.name,controller: nameController,),
              SizedBox(height: 12,),
              CustomTextField(hintText: AppString.email, prefixIcon: AppAssets.email,controller: emailController,),
              SizedBox(height: 12,),
              CustomTextField(hintText: AppString.password, prefixIcon: AppAssets.lock,controller: passwordController,
                isPassword: isObscurePassword,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => isObscurePassword = !isObscurePassword),
                  icon: Icon(isObscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white),
                ),),
              SizedBox(height: 12,) ,
              CustomTextField(hintText: AppString.confirmPassword, prefixIcon: AppAssets.lock,controller: confirmPasswordController,
                isPassword: isObscureConfirm,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => isObscureConfirm = !isObscureConfirm),
                  icon: Icon(isObscureConfirm ? Icons.visibility_off : Icons.visibility, color: Colors.white),
                ),),
              SizedBox(height: 12,),
              CustomTextField(hintText: AppString.phone, prefixIcon: AppAssets.phone,controller: phoneController,),
              SizedBox(height: 20,),
              CustomButton(text: AppString.createAccount,  onPress: () async {
                if (passwordController.text != confirmPasswordController.text) {
                  showMessage(context, "Passwords do not match", title: "Error", posText: "ok");
                  return;
                }
                if (nameController.text.isEmpty || emailController.text.isEmpty) {
                  showMessage(context, "Please fill all fields", title: "Error", posText: "ok");
                  return;
                }

                try {
                  showLoading(context);
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                    email: emailController.text.trim(),
                    password: passwordController.text,
                  );
                  UserData.currentUser = UserData(
                    id: credential.user!.uid,
                    name: nameController.text,
                    phoneNumber: phoneController.text,
                    email: emailController.text.trim(),
                    avatar:selectedAvatar,
                  );
                  createUserInFirestore(UserData.currentUser!);
                  if (mounted) {
                    Navigator.pop(context);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MainScreen()),
                          (route) => false,
                    );
                  }
                } on FirebaseAuthException catch (e) {
                  Navigator.pop(context); // hide loading
                  var message = "";
                  if (e.code == 'weak-password') {
                    message = 'The password provided is too weak.';
                  } else if (e.code == 'email-already-in-use') {
                    message = 'The account already exists for that email.';
                  } else {
                    message = "Something went wrong please try again later";
                  }
                  showMessage(context, message, title: "Error", posText: "ok");
                } catch (e) {
                  print(e);
                }
              },),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(AppString.haveAccount,style: AppTextStyle.white12normal,),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(AppString.login, style: AppTextStyle.yello12W400,),
                  ),
                ],
              ),
              SizedBox(height: 20,),
             CustomRow(),
            ],
          ),
        ),
      ),
    );
  }
}
