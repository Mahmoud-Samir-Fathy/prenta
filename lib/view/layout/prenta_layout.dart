import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/Customize/customize.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class prenta_layout extends StatefulWidget {

  @override
  State<prenta_layout> createState() => _prenta_layoutState();
}
class _prenta_layoutState extends State<prenta_layout> {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrentaCubit,PrentaStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed:(){
              navigateTo(context, customize());
            } ,
            backgroundColor: firstColor,
            child: Icon(Ionicons.shirt,color:forthColor),
          ),
          bottomNavigationBar: AnimatedBottomNavigationBar(
            backgroundColor: firstColor,
              inactiveColor: forthColor,
              activeColor: thirdColor,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.verySmoothEdge,
              icons: PrentaCubit.get(context).IconList,
              activeIndex: PrentaCubit.get(context).currentIndex,
              onTap: (index){
                 PrentaCubit.get(context).ChangeBottomNav(index);
              }),
          body: PrentaCubit.get(context).screens[PrentaCubit.get(context).currentIndex],

          // Stack(
          //   children: [
          //     Positioned.fill(
          //       child: PersistentTabView(
          //         context,
          //         controller: PersistentTabController(initialIndex: PrentaCubit.get(context).currentIndex),
          //         screens:PrentaCubit.get(context).screens,
          //         items: navBarsItems(),
          //         backgroundColor: firstColor,
          //         navBarStyle: NavBarStyle.style19,
          //         confineInSafeArea: true,
          //         handleAndroidBackButtonPress: true,
          //         resizeToAvoidBottomInset: true,
          //         stateManagement: true,
          //         hideNavigationBarWhenKeyboardShows: true,
          //         decoration: NavBarDecoration(
          //           colorBehindNavBar: Colors.transparent,
          //         ),
          //         popAllScreensOnTapOfSelectedTab: true,
          //         itemAnimationProperties: ItemAnimationProperties(
          //           duration: Duration(milliseconds: 200),
          //           curve: Curves.ease,
          //         ),
          //         screenTransitionAnimation: ScreenTransitionAnimation(
          //           animateTabTransition: true,
          //           curve: Curves.ease,
          //           duration: Duration(milliseconds: 200),
          //         ),
          //       ),
          //     ),
          //     Positioned(
          //       bottom: MediaQuery.of(context).size.height * 0.09,
          //       right: MediaQuery.of(context).size.width * 0.05,
          //       child: FloatingActionButton(
          //         backgroundColor: firstColor,
          //         onPressed: (){
          //           navigateTo(context, customize());
          //         },
          //         child: Icon(Ionicons.shirt,color: Colors.white,),
          //       ),
          //     ),
          //   ],
          // ),
        );
      },
    );
  }

  // List<PersistentBottomNavBarItem> navBarsItems() {
  //   return [
  //     PersistentBottomNavBarItem(
  //       icon: Icon(Ionicons.home),
  //       title: "Home",
  //       activeColorPrimary: thirdColor,
  //       inactiveColorPrimary: forthColor,
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: Icon(Ionicons.bag),
  //       title: "Search",
  //       activeColorPrimary: thirdColor,
  //       inactiveColorPrimary: forthColor,
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: Icon(Ionicons.archive),
  //       title: "History",
  //       activeColorPrimary: thirdColor,
  //       inactiveColorPrimary: forthColor,
  //     ),
  //     PersistentBottomNavBarItem(
  //       icon: Icon(Ionicons.person),
  //       title: "Profile",
  //       activeColorPrimary: thirdColor,
  //       inactiveColorPrimary: forthColor,
  //     ),
  //   ];
  // }
}
