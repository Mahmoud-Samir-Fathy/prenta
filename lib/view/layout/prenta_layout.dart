import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/Customize/customize.dart';
import 'package:printa/view/user_profile/profile.dart';
import 'package:printa/view/order_status/user_orders/user_orders.dart';
import 'package:printa/view/wishlist/wishlist.dart';

import '../homeScreen/homescreen.dart';

class prenta_layout extends StatefulWidget {
  @override
  State<prenta_layout> createState() => _prenta_layoutState();
}

class _prenta_layoutState extends State<prenta_layout> {
  int currentIndex = 0;

  void ChangeBottomNav(int index) {
    setState(() {
      currentIndex = index;
    });
  }
  List<Widget> screens=[
    HomeScreen(),
    wishlist(),
    user_orders(),
    profile_screen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: PersistentTabView(
              context,
              controller: PersistentTabController(initialIndex: currentIndex),
              screens: screens,
              items: _navBarsItems(),
              backgroundColor: firstColor,
              navBarStyle: NavBarStyle.style19,
              confineInSafeArea: true,
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset: true,
              stateManagement: true,
              hideNavigationBarWhenKeyboardShows: true,
              decoration: NavBarDecoration(
                colorBehindNavBar: Colors.transparent,
              ),
              popAllScreensOnTapOfSelectedTab: true,
              itemAnimationProperties: ItemAnimationProperties(
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimation(
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.09,
            right: MediaQuery.of(context).size.width * 0.05,
            child: FloatingActionButton(
              backgroundColor: firstColor,
              onPressed: (){
                navigateTo(context, customize());
              },
              child: Icon(Ionicons.shirt,color: Colors.white,),
            ),
          ),
        ],
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Ionicons.home),
        title: "Home",
        activeColorPrimary: thirdColor,
        inactiveColorPrimary: forthColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Ionicons.bag),
        title: "Search",
        activeColorPrimary: thirdColor,
        inactiveColorPrimary: forthColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Ionicons.archive),
        title: "History",
        activeColorPrimary: thirdColor,
        inactiveColorPrimary: forthColor,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Ionicons.person),
        title: "Profile",
        activeColorPrimary: thirdColor,
        inactiveColorPrimary: forthColor,
      ),
    ];
  }
}
