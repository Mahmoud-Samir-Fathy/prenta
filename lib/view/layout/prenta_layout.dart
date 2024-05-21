import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:printa/view/layout/productScreen.dart';
import 'package:printa/view/user_profile/profile.dart';
import 'package:printa/view/order_status/user_orders/user_orders.dart';
import 'package:printa/view/wishlist/wishlist.dart';

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
    product_screen(),
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
              backgroundColor: Colors.black,
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
              onPressed: (){},
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: "Home",
        activeColorPrimary: Colors.blue,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.search),
        title: "Search",
        activeColorPrimary: Colors.teal,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.history),
        title: "History",
        activeColorPrimary: Colors.blueAccent,
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: Colors.deepOrange,
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
}
