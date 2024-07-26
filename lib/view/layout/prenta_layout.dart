import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/Customize/customize.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class PrentaLayout extends StatefulWidget {

  @override
  State<PrentaLayout> createState() => _prenta_layoutState();
}
class _prenta_layoutState extends State<PrentaLayout> {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrentaCubit,PrentaStates>(
      listener: (context,state){},
      builder: (context,state){
        return Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0), // Adjust as per your requirement
            ),
            onPressed:(){
              navigateTo(context, Customize());
            } ,
            backgroundColor:PrentaCubit.get(context).isDark?thirdColor:firstColor,
            child: Icon(Ionicons.shirt,color:PrentaCubit.get(context).isDark?secondColor:forthColor),
          ),
          bottomNavigationBar: AnimatedBottomNavigationBar(
            leftCornerRadius: 20,
            rightCornerRadius: 20,
            backgroundColor: PrentaCubit.get(context).isDark?thirdColor:firstColor,
              inactiveColor: PrentaCubit.get(context).isDark?secondColor:forthColor,
              activeColor: PrentaCubit.get(context).isDark?firstColor:thirdColor,
              gapLocation: GapLocation.center,
              notchSmoothness: NotchSmoothness.sharpEdge,
              icons: PrentaCubit.get(context).IconList,
              activeIndex: PrentaCubit.get(context).currentIndex,
              onTap: (index){
                 PrentaCubit.get(context).ChangeBottomNav(index);
              }),
          body: PrentaCubit.get(context).screens[PrentaCubit.get(context).currentIndex],
        );
      },
    );
  }
}
