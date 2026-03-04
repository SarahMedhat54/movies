import 'package:flutter/material.dart';
import 'package:move/core/app_assets.dart';
import 'package:move/core/app_colors.dart';
import 'package:move/core/app_style.dart';

import '../../widget/custom_button.dart';
import '../edit_profile/edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 2,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.lightBlack,

          body: Column(children: [
           Padding(
             padding: const EdgeInsets.only(top: 30),
             child: Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
               Column(
                 children: [
                   CircleAvatar(
                     radius: 55,
                     child: Image.asset(AppAssets.ProfilePhoto,),
                   ),
                   SizedBox(height: 20,),
                   Text("John Safwat",style: AppTextStyle.white20w700,)
                 ],
               ),
                 Column(
                   children: [
                   Text("12",style: AppTextStyle.white36w700,),
                   Text("Wish List",style: AppTextStyle.white24w700,)
                 ],),
                 Column(
                   children: [
                     Text("10",style: AppTextStyle.white36w700,),
                     Text("History",style: AppTextStyle.white24w700,)
                   ],)
             ],),
           ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 9),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex:2,
                    child: CustomButton(text: "Edit Profile",onPress: (){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  EditProfileScreen(),
                        ),
                      );

                    },backgroundColor: AppColors.yellow,
                    textStyle:AppTextStyle.black20W400 ,
                    ),
                  ),
                  SizedBox(width: 12,),
                  Flexible(
                    flex: 1,
                    child: CustomButton(text: "Exit",onPress: (){},backgroundColor: AppColors.redE82626,
                      textStyle:AppTextStyle.white20w400 ,
                      icon: Icon(Icons.output_rounded,color: AppColors.white,),

                    ),
                  ),
                ],
              ),
            ),
            TabBar(
              indicatorColor: AppColors.yellow,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              dividerColor: Colors.transparent,
              indicatorSize:TabBarIndicatorSize.tab ,

              tabs:  [
                Tab(
                 icon: Image.asset(AppAssets.WatchList),
                  text: "Watch List",
                ),
                Tab(
                  icon: Icon(Icons.folder,color: AppColors.yellow,size: 30,),
                  text: "History",
                ),
              ],
            ),
            /// TAB CONTENT
            Expanded(
              child: TabBarView(
                children: [
                  /// Watch List Content
                  Center(
                    child: Image.asset(
                      AppAssets.ZeroState, // your popcorn image
                      height: 150,
                    ),
                  ),

                  /// History Content
                  Center(
                    child: Image.asset(
                      AppAssets.ZeroState,
                      height: 150,
                    ),
                  ),
                ],
              ),
            ),

          ],),

        ),
      ),
    );
  }
}
