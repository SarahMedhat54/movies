import 'package:flutter/material.dart';
import 'package:move/core/app_assets.dart';
import 'package:move/core/app_colors.dart';
import 'package:move/core/app_style.dart';
import 'package:move/widget/custom_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.black,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color: AppColors.yellow,)),
        centerTitle: true,
        title: Text("Pick Avatar",style: AppTextStyle.yello16W400,),
      ),
      backgroundColor: AppColors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              child: Image.asset(AppAssets.ProfilePhoto),
            ),
          ),
          SizedBox(height: 40,),
            TextField(
              controller: nameController,
            style: TextStyle(color: AppColors.white),
            decoration:InputDecoration(
              prefixIcon: Icon(Icons.person,color: AppColors.white,),
              filled: true,
              fillColor: AppColors.lightBlack,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ) ,

          ),
            SizedBox(height: 20,),
            TextField(
              controller: phoneController,
              style: TextStyle(color: AppColors.white),
              decoration:InputDecoration(
                prefixIcon: Icon(Icons.phone,color: AppColors.white,),
                filled: true,
                fillColor: AppColors.lightBlack,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ) ,

            ),
            SizedBox(height: 40,),
            Expanded(child: Text("Reset Password",style: AppTextStyle.white20w400,)),
            CustomButton(text: "Delete Account",onPress: (){
            },backgroundColor: AppColors.redE82626,
              textStyle:AppTextStyle.white20w400 ,
            ),
            CustomButton(text: "Update Data",onPress: (){
            },backgroundColor: AppColors.yellow,
              textStyle:AppTextStyle.black20W400 ,
            ),

        ],),
      ),
    );
  }
}
