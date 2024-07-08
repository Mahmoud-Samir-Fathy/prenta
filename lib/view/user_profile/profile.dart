import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/components/constants.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/login&register_screen/account_screen/account_screen.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';
import '../edit_user_profile/edit_user_profile.dart';

class profile_screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (BuildContext context, PrentaStates state) {},
      builder: (BuildContext context, PrentaStates state) {
        var cubit = PrentaCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            title: Text(
              'Profile Settings',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
          ),
          body: ConditionalBuilder(
            condition: cubit.userInfo != null,
            builder: (context) => SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        radius: 64,
                        child: CircleAvatar(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          radius: 60,
                          backgroundImage: cubit.userInfo!.profileImage != null
                              ? NetworkImage('${cubit.userInfo!.profileImage}')
                              : AssetImage('assets/images/default_profile.png') as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text('${cubit.userInfo!.firstName} ${cubit.userInfo!.lastName}'),
                      SizedBox(height: 5),
                      Text('${cubit.userInfo!.email}'),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Ionicons.person),
                            SizedBox(width: 15),
                            Text('Edit Profile'),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                navigateTo(context, edit_profile());
                              },
                              icon: Icon(Ionicons.chevron_forward_outline),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Ionicons.settings),
                            SizedBox(width: 15),
                            Text('Change Themes'),
                            Spacer(),
                            IconButton(
                              onPressed: () {
                                cubit.changeMode();
                              },
                              icon: Icon(Ionicons.chevron_forward_outline),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Ionicons.wallet),
                            SizedBox(width: 15),
                            Text('Orders'),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Ionicons.chevron_forward_outline),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Support',
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Ionicons.information),
                            SizedBox(width: 15),
                            Text('Help Center'),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Ionicons.chevron_forward_outline),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Ionicons.information),
                            SizedBox(width: 15),
                            Text('Terms of Service'),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Ionicons.chevron_forward_outline),
                            ),
                          ],
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: [
                            Icon(Ionicons.chatbox_outline),
                            SizedBox(width: 15),
                            Text('Support Chat'),
                            Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(Ionicons.chevron_forward_outline),
                            ),
                          ],
                        ),
                        SizedBox(height: 30),
                        Center(
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: cubit.isDark ? Colors.white : firstColor),
                            ),
                            child: MaterialButton(
                              height: 60,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Row(
                                children: [
                                  Icon(Ionicons.exit_outline),
                                  SizedBox(width: 15),
                                  Text('Sign out'),
                                ],
                              ),
                              onPressed: () {
                                _showSignOutDialog(context, cubit.isDark ? Colors.white : firstColor);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            fallback: (context) => Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }
}

void _showSignOutDialog(BuildContext context, Color color) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Align(
          alignment: AlignmentDirectional.center,
          child: Text('Sign Out'),
        ),
        content: Container(
          height: 100,
          child: Center(
            child: Text(
              'Do you want to sign out?',
              style: TextStyle(fontWeight: FontWeight.w300),
            ),
          ),
        ),
        actions: [
          Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: firstColor),
            ),
            child: MaterialButton(
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ),
          Container(
            height: 50,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: color),
            ),
            child: MaterialButton(
              color: color,
              height: 50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              onPressed: () {
                  signout(context);
              },
              child: Text(
                'Sign Out',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      );
    },
  );
}
