import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/view/change_password/change_password.dart';
import 'package:printa/view/edit_address/edit_address.dart';
import 'package:printa/view/user_profile/profile.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';

class edit_profile extends StatelessWidget {

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrentaCubit,PrentaStates>(
      listener: (context,state){

      },
      builder: (context,state){
        var cubit=PrentaCubit.get(context).userInfo;
        var userImage=PrentaCubit.get(context).userImage;
        firstNameController.text=cubit!.firstName!;
        lastNameController.text=cubit.lastName!;
        emailController.text=cubit.email!;
        phoneController.text=cubit.phoneNumber.toString();

        return
          Scaffold(
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Ionicons.chevron_back_outline),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Text('Edit Profile'),
              centerTitle: true,
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: AlignmentDirectional.bottomEnd,
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          radius: 64,
                          child: CircleAvatar(
                            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                            radius: 60,
                            backgroundImage: userImage == null
                                ? NetworkImage('${cubit.profileImage}') as ImageProvider<Object>
                                : FileImage(userImage) as ImageProvider<Object>,
                          ),
                        ),
                        IconButton(onPressed: (){
                          PrentaCubit.get(context).getProfileImage();
                        }, icon: Icon(Ionicons.camera))

                      ],
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('First Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              SizedBox(height: 8),
                              defaultTextFormField(
                                controller: firstNameController,
                                KeyboardType: TextInputType.text,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your first name';
                                  } else {
                                    return null;
                                  }
                                },
                                lable: 'First Name',
                                prefix: Icons.person,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Last Name', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                              SizedBox(height: 8),
                              defaultTextFormField(
                                controller: lastNameController,
                                KeyboardType: TextInputType.text,
                                validate: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your Last name';
                                  } else {
                                    return null;
                                  }
                                },
                                lable: 'Last Name',
                                prefix: Icons.person,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Your Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8),
                        defaultTextFormField(
                          controller: emailController,
                          KeyboardType: TextInputType.emailAddress,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your email address';
                            } else {
                              return null;
                            }
                          },
                          lable: 'xxx@gmail.com',
                          prefix: Icons.email_outlined,
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phone Number', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                        SizedBox(height: 8),
                        defaultTextFormField(
                          controller: phoneController,
                          KeyboardType: TextInputType.phone,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            } else {
                              return null;
                            }
                          },
                          lable: '+02*******',
                          prefix: Icons.phone,
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),

                    Row(
                      children: [
                        Icon(Icons.password),
                        SizedBox(width: 15,),
                        Text('Change Password'),
                        Spacer(),
                        IconButton(onPressed: (){
                          navigateTo(context, change_password());
                        }, icon:Icon( Icons.arrow_forward_ios_sharp))
                      ],
                    ),
                    SizedBox(height: 15,),

                    Row(
                      children: [
                        Icon(Icons.home),
                        SizedBox(width: 15,),
                        Text('Change Address'),
                        Spacer(),
                        IconButton(onPressed: (){
                          navigateTo(context, edit_address());
                        }, icon:Icon( Icons.arrow_forward_ios_sharp))
                      ],
                    ),
                    SizedBox(height: 30),
                    defaultMaterialButton(text: 'Submit', Function: (){
                      PrentaCubit.get(context).UploadUserImage(
                        password: cubit.password.toString(),
                          firstName: firstNameController.text,
                          lastName: lastNameController.text,
                          email: emailController.text,
                          phoneNumber: phoneController.text);
                    })
                  ],
                ),
              ),
            ),
          );
      },
    );
  }
}
