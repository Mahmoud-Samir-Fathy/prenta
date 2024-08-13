import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/components/constants.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view_model/change_mode/mode_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';
import '../edit_user_profile/edit_user_profile.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

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
            title: const Text(
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
                              : const AssetImage('assets/images/default_profile.png') as ImageProvider,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text('${cubit.userInfo!.firstName} ${cubit.userInfo!.lastName}'),
                      const SizedBox(height: 5),
                      Text('${cubit.userInfo!.email}'),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Icon(Ionicons.person),
                            const SizedBox(width: 15),
                            const Text('Edit Profile'),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                navigateTo(context, EditUserProfile());
                              },
                              icon: const Icon(Ionicons.chevron_forward_outline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Icon(Ionicons.settings),
                            const SizedBox(width: 15),
                            const Text('Change Themes'),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                ModeCubit.get(context).changeMode();
                              },
                              icon: const Icon(Ionicons.chevron_forward_outline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Icon(Ionicons.wallet),
                            const SizedBox(width: 15),
                            const Text('Orders'),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Ionicons.chevron_forward_outline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Support',
                          style: TextStyle(fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Icon(Ionicons.information),
                            const SizedBox(width: 15),
                            const Text('Help Center'),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Ionicons.chevron_forward_outline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Icon(Ionicons.information),
                            const SizedBox(width: 15),
                            const Text('Terms of Service'),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Ionicons.chevron_forward_outline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            const Icon(Ionicons.chatbox_outline),
                            const SizedBox(width: 15),
                            const Text('Support Chat'),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Ionicons.chevron_forward_outline),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Center(
                          child: Container(
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(color: ModeCubit.get(context).isDark ? Colors.white : firstColor),
                            ),
                            child: MaterialButton(
                              height: 60,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(30)),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Ionicons.exit_outline),
                                  SizedBox(width: 15),
                                  Text('Sign out'),
                                ],
                              ),
                              onPressed: () {
                                _showSignOutDialog(context, ModeCubit.get(context).isDark ? secondColor : firstColor);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            fallback: (context) => const Center(child: CircularProgressIndicator()),
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
        title: const Align(
          alignment: AlignmentDirectional.center,
          child: Text('Sign Out'),
        ),
        content: Container(
          height: 100,
          child: const Center(
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
              color: ModeCubit.get(context).isDark?Colors.grey[700]:Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: firstColor),
            ),
            child: MaterialButton(
              height: 50,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
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
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              onPressed: () {
                  signOut(context);
              },
              child: const Text(
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
