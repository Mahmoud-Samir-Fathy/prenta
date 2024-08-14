import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/view/change_password/change_password.dart';
import 'package:printa/view/edit_address/edit_address.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class EditUserProfile extends StatelessWidget {

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  EditUserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    // Call getUserData to fetch the user data when the screen is built
    PrentaCubit.get(context).getUserData();
    PrentaCubit.get(context).clearTempImage();


    return BlocConsumer<PrentaCubit, PrentaStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = PrentaCubit.get(context);
        // Handle loading state
        if (state is PrentaLoadingState || cubit.userInfo == null) {
          return Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Ionicons.chevron_back_outline),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: const Text('Edit Profile'),
              centerTitle: true,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        var userInfo = cubit.userInfo;
        var userImage = cubit.userImage;

        // Populate the text controllers with user data
        firstNameController.text = userInfo!.firstName!;
        lastNameController.text = userInfo.lastName!;
        emailController.text = userInfo.email!;
        phoneController.text = userInfo.phoneNumber.toString();

        return Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Ionicons.chevron_back_outline),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text('Edit Profile'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (state is UpdateUserInfoLoadingState)
                    const LinearProgressIndicator(),
                  Stack(
                    alignment: AlignmentDirectional.bottomEnd,
                    children: [
                      CircleAvatar(
                        backgroundColor:
                        Theme.of(context).scaffoldBackgroundColor,
                        radius: 64,
                        child: CircleAvatar(
                          backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                          radius: 60,
                          backgroundImage: userImage == null
                              ? NetworkImage('${userInfo.profileImage}')
                          as ImageProvider<Object>
                              : FileImage(userImage) as ImageProvider<Object>,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            PrentaCubit.get(context).getProfileImage();
                          },
                          icon: const Icon(Ionicons.camera))
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('First Name',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            defaultTextFormField(
                              controller: firstNameController,
                              keyboardType: TextInputType.text,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your first name';
                                } else {
                                  return null;
                                }
                              },
                              label: 'First Name',
                              prefix: Icons.person,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Last Name',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 8),
                            defaultTextFormField(
                              controller: lastNameController,
                              keyboardType: TextInputType.text,
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your Last name';
                                } else {
                                  return null;
                                }
                              },
                              label: 'Last Name',
                              prefix: Icons.person,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your Email',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      defaultTextFormField(
                        enabled: false,
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email address';
                          } else {
                            return null;
                          }
                        },
                        label: 'xxx@gmail.com',
                        prefix: Icons.email_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Phone Number',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
                      defaultTextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone number';
                          } else {
                            return null;
                          }
                        },
                        label: '+02*******',
                        prefix: Icons.phone,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  if(userInfo.isEmailAndPassword==true) Row(
                    children: [
                      const Icon(Icons.password),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text('Change Password'),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            navigateTo(context, ChangePassword());
                          },
                          icon: const Icon(Icons.arrow_forward_ios_sharp))
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      const Icon(Icons.home),
                      const SizedBox(
                        width: 15,
                      ),
                      const Text('Change Address'),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            navigateTo(context, EditAddress());
                          },
                          icon: const Icon(Icons.arrow_forward_ios_sharp))
                    ],
                  ),
                  const SizedBox(height: 30),
                  defaultMaterialButton(text: 'Submit', function: () {
                    PrentaCubit.get(context).UploadUserImage(
                      context: context,
                      password: userInfo.password.toString(),
                      firstName: firstNameController.text,
                      lastName: lastNameController.text,
                      email: emailController.text,
                      phoneNumber: phoneController.text,
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}