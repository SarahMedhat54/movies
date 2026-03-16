import 'package:flutter/material.dart';
import 'package:move/screens/profile/profile_screen.dart';
import '../widget/custome_bottomBar.dart';
import 'home/home_screen.dart';
import 'browse/browse_screen.dart';
import 'home/search_screen.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = "main_screen";
  final int initialIndex;
  const MainScreen({super.key,this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  //int selectedTabIndex = 0;
  late int selectedTabIndex;
  @override
  void initState() {
    super.initState();
    selectedTabIndex = widget.initialIndex;
  }

  final List<Widget> tabs = const [
    HomeScreen(),
    SearchScreen(),   // SearchScreen later
    BrowseScreen(),
    ProfileScreen()  , // ProfileScreen later
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[selectedTabIndex],
      bottomNavigationBar: BottomNavWidget(
        currentIndex: selectedTabIndex,
        onTap: (index) {
          setState(() {
            selectedTabIndex = index;
          });
        },
      ),
    );
  }
}