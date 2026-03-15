import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move/core/app_assets.dart';
import 'package:move/core/app_colors.dart';
import 'package:move/core/app_style.dart';
import 'package:move/widget/custom_button.dart';

import '../../core/app_route.dart';
import '../../firebase/firebase_store.dart';
import '../../model/user_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  List<String> avatars = [
    AppAssets.avatar1,
    AppAssets.avatar2,
    AppAssets.avatar3,
    AppAssets.avatar4,
    AppAssets.avatar5,
    AppAssets.avatar6,
    AppAssets.avatar7,
    AppAssets.avatar8,
  ];

  String? selectedAvatar;


  UserData? user;
  void loadUser() async {
    var uid = FirebaseAuth.instance.currentUser!.uid;
    user = await getUserFromFirestore(uid);
    nameController.text = user!.name;
    phoneController.text = user!.phoneNumber;
    selectedAvatar = user!.avatar;
    setState(() {});
  }

  Future<void> deleteAccount(String password) async {
    try {
      var firebaseUser = FirebaseAuth.instance.currentUser;

      if (firebaseUser != null) {

        AuthCredential credential = EmailAuthProvider.credential(
          email: firebaseUser.email!,
          password: password,
        );

        /// re-authenticate
        await firebaseUser.reauthenticateWithCredential(credential);

        /// delete from firestore first
        await FirebaseFirestore.instance
            .collection("users")
            .doc(firebaseUser.uid)
            .delete();

        /// delete from authentication
        await firebaseUser.delete();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account Deleted Successfully")),
        );

        Navigator.pushReplacement(context, AppRoutes.login);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Wrong Password")),
      );
    }
  }
  @override
  void initState() {
    super.initState();
    loadUser();
  }
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
            child:
            // CircleAvatar(
            //
            //   radius: 60,
            //   //child: Image.asset(AppAssets.ProfilePhoto),
            //   backgroundImage: user == null
            //       ? AssetImage(AppAssets.ProfilePhoto)
            //       : AssetImage(user!.avatar),
            // ),

            GestureDetector(
              onTap: () {
                showAvatarPicker();
              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage: selectedAvatar == null
                    ? AssetImage(AppAssets.ProfilePhoto)
                    : AssetImage(selectedAvatar!),
              ),
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
            SizedBox(height: 35,),
            Expanded(child: Text("Reset Password",style: AppTextStyle.white20w400,)),
            CustomButton(text: "Delete Account",onPress: (){
              showDeleteDialog();
            },backgroundColor: AppColors.redE82626,
              textStyle:AppTextStyle.white20w400 ,
            ),
            CustomButton(text: "Update Data",  onPress: () async {

              var uid = FirebaseAuth.instance.currentUser!.uid;

              UserData updatedUser = UserData(
                id: uid,
                name: nameController.text,
                // avatar: user!.avatar,
                avatar: selectedAvatar!,
                email: user!.email,
                phoneNumber:  phoneController.text,
              );

              await updateUserInFirestore(updatedUser);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Profile Updated")),
              );
              Navigator.pushReplacement(context, AppRoutes.profile);

            },backgroundColor: AppColors.yellow,
              textStyle:AppTextStyle.black20W400 ,
            ),

        ],),
      ),
    );
  }

  void showDeleteDialog() {
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: TextField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              hintText: "Enter your password",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await deleteAccount(passwordController.text);
                Navigator.pushReplacement(context, AppRoutes.onboarding);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }
  void showAvatarPicker() {

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.black,
      builder: (context) {

        return GridView.builder(
          padding: EdgeInsets.all(20),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
          ),
          itemCount: avatars.length,
          itemBuilder: (context, index) {

            return GestureDetector(
              onTap: () {

                setState(() {
                  selectedAvatar = avatars[index];
                });

                Navigator.pop(context);
              },
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.yellow,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(8),
                child: Image.asset(avatars[index]),
              ),
            );
          },
        );
      },
    );
  }

}



