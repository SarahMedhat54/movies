import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:move/core/app_assets.dart';
import 'package:move/core/app_colors.dart';
import 'package:move/core/app_route.dart';
import 'package:move/core/app_style.dart';
import 'package:move/widget/movie_cerd.dart';
import 'package:move/model/movie_model.dart';

import '../../firebase/firebase_store.dart';
import '../../model/user_data.dart';
import '../../widget/custom_button.dart';
import '../../core/cache_helper.dart';
import '../edit_profile/edit_profile_screen.dart';
import 'history_manager.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserData? user;
  // void loadUser() async {
  //   var uid = FirebaseAuth.instance.currentUser!.uid;
  //   user = await getUserFromFirestore(uid);
  //   setState(() {});
  // }
  void loadUser() async {
    user = CacheHelper.getUser();
    if (user == null) {
      var firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        print("User not logged in");
        return;
      }
      var uid = firebaseUser.uid;
      user = await getUserFromFirestore(uid);
      if (user != null) {
        await CacheHelper.saveUser(user!);
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    loadUser();
    print(FirebaseAuth.instance.currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.lightBlack,

        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 55,
                          backgroundImage: user == null
                              ? AssetImage(AppAssets.ProfilePhoto)
                              : AssetImage(user!.avatar),
                          //child: Image.asset(AppAssets.ProfilePhoto,),
                        ),
                        SizedBox(height: 20),
                        //  Text("John Safwat",style: AppTextStyle.white20w700,)
                        Text(
                          user?.name ?? "Loading...",
                          style: AppTextStyle.white20w700,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        //Text("12",style: AppTextStyle.white36w700,),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("watchlist")
                              .where(
                                "userId",
                                isEqualTo:
                                    FirebaseAuth.instance.currentUser!.uid,
                              )
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return Text("0", style: AppTextStyle.white36w700);
                            }

                            int count = snapshot.data!.docs.length;

                            return Text(
                              "$count",
                              style: AppTextStyle.white36w700,
                            );
                          },
                        ),

                        Text("Wish List", style: AppTextStyle.white24w700),
                      ],
                    ),
                    Column(
                      children: [
                        // Text("10",style: AppTextStyle.white36w700,),
                        Text(
                          "${HistoryManager.historyMovies.length}",
                          style: AppTextStyle.white36w700,
                        ),
                        Text("History", style: AppTextStyle.white24w700),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 15,
                  horizontal: 9,
                ),
                child: Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 2,
                      child: CustomButton(
                        text: "Edit Profile",
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfileScreen(),
                            ),
                          );
                        },
                        backgroundColor: AppColors.yellow,
                        textStyle: AppTextStyle.black20W400,
                      ),
                    ),
                    SizedBox(width: 12),
                    Flexible(
                      flex: 1,
                      child: CustomButton(
                        text: "Exit",
                        onPress: () async {
                          await CacheHelper.clearCache();
                          await FirebaseAuth.instance.signOut();

                          /// go to onboarding/login screen
                          Navigator.pushReplacement(
                            context,
                            AppRoutes.onboarding,
                          );
                        },
                        backgroundColor: AppColors.redE82626,
                        textStyle: AppTextStyle.white20w400,
                        icon: Icon(
                          Icons.output_rounded,
                          color: AppColors.white,
                        ),
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
                indicatorSize: TabBarIndicatorSize.tab,

                tabs: [
                  Tab(
                    icon: Image.asset(AppAssets.WatchList),
                    text: "Watch List",
                  ),
                  Tab(
                    icon: Icon(Icons.folder, color: AppColors.yellow, size: 30),
                    text: "History",
                  ),
                ],
              ),

              /// TAB CONTENT
              Expanded(
                child: TabBarView(
                  children: [
                    /// Watch List Content
                    // Center(
                    //   child: Image.asset(
                    //     AppAssets.ZeroState, // your popcorn image
                    //     height: 150,
                    //   ),
                    // ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("watchlist")
                          .where(
                            "userId",
                            isEqualTo: FirebaseAuth.instance.currentUser!.uid,
                          )
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }

                        var movies = snapshot.data!.docs;

                        if (movies.isEmpty) {
                          return Center(
                            child: Image.asset(
                              AppAssets.ZeroState,
                              height: 150,
                            ),
                          );
                        }

                        return GridView.builder(
                          padding: EdgeInsets.all(12),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 10,
                                childAspectRatio: 0.65,
                              ),
                          itemCount: movies.length,
                          itemBuilder: (context, index) {
                            var movieMap = movies[index].data();
                            var movieModel = MovieModel.fromFirestore(movieMap);

                            return ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: MovieCard(movie: movieModel),
                            );
                          },
                        );
                      },
                    ),

                    /// History Content
                    // Center(
                    //   child: Image.asset(
                    //     AppAssets.ZeroState,
                    //     height: 150,
                    //   ),
                    // ),
                    HistoryManager.historyMovies.isEmpty
                        ? Center(
                            child: Image.asset(
                              AppAssets.ZeroState,
                              height: 150,
                            ),
                          )
                        : GridView.builder(
                            padding: EdgeInsets.all(12),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  mainAxisSpacing: 10,
                                  childAspectRatio: 0.65,
                                ),
                            itemCount: HistoryManager.historyMovies.length,
                            itemBuilder: (context, index) {
                              final movie = HistoryManager.historyMovies[index];

                              return ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: MovieCard(movie: movie),
                              );
                            },
                          ),
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
