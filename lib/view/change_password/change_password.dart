import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/edit_user_profile/edit_user_profile.dart';
import 'package:printa/view/user_profile/profile.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';
import '../../shared/components/components.dart';

class change_password extends StatelessWidget{
  var oldPasswordController=TextEditingController();
  var newPasswordController=TextEditingController();
  var confirmNewPasswordController=TextEditingController();
  var formKey=GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrentaCubit,PrentaStates>(

      listener: (context,state){
        if(state is PrentaGetUserSuccessState) {
          navigateTo(context, profile_screen());
          showToast(context, title: 'Success', description: 'Password has been updated', state: ToastColorState.success, icon: Ionicons.thumbs_up_outline);
        }
      },
      builder:(context,state){
        var cubit=PrentaCubit.get(context);
        return  Scaffold(
          backgroundColor: thirdColor,
          appBar: AppBar(
            backgroundColor: thirdColor,
            leading: IconButton(icon: Icon(Ionicons.chevron_back_outline),onPressed: (){
              Navigator.pop(context);
            },),
            title: Text('Change Password'),
            centerTitle:true ,
          ),
          body: Container(
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,)),
                      SizedBox(height: 8),
                      defaultTextFormField(
                          controller: oldPasswordController,
                          KeyboardType: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your current password';
                            } else  if (value !=cubit.userInfo!.password.toString()){
                              return 'Password donot match the old password' ;
                            }else {
                              return null;
                            }
                          },
                          isPassword: cubit.isPasswordShown,
                          lable: 'Current Password',
                          prefix:  Ionicons.lock_closed_outline,
                          suffix: cubit.suffixIcon,
                          suffixpressed: (){
                            cubit.ChangePasswordVisibility();
                        }
                      ),
                      SizedBox(height: 8,),
                      Align(alignment: AlignmentDirectional.bottomEnd,
                          child: TextButton(onPressed: (){}, child: Text('Forget Password?'))),
                      SizedBox(height: 15,),
                      Text('New Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8),
                      defaultTextFormField(
                          controller: newPasswordController,
                          KeyboardType: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your new password';
                            } else {
                              return null;
                            }
                          },
                          lable: 'New Password',
                          prefix: Ionicons.key_outline,
                          suffix: cubit.suffixIcon,
                          isPassword: cubit.isPasswordShown,

                          suffixpressed: (){
                            cubit.ChangePasswordVisibility();
                          }
                      ),
                      SizedBox(height: 15,),
                      Text('Confirm Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      SizedBox(height: 8),
                      defaultTextFormField(
                          controller: confirmNewPasswordController,
                          KeyboardType: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value!.isEmpty) {
                              return 'Please type the correct password';
                            } else if (value != newPasswordController.text) {
                              return 'Passwords do not match';
                            } else {
                              return null;
                            }
                          },
                          lable: 'Confirm password',
                          prefix: Ionicons.key_outline,
                          isPassword: cubit.isPasswordShown,
                          suffix: cubit.suffixIcon,
                        suffixpressed: (){
                            cubit.ChangePasswordVisibility();
                        }
                      ),

                      SizedBox(height: 40,),
                      Center(
                          child: defaultMaterialButton(text: 'Submit', Function: ()
                      {
                        if (formKey.currentState!.validate()) {
                              cubit.updateUserPassword(
                                  password:newPasswordController.text
                              );

                        }
                      }))
                    ],
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(40),
                    topLeft: Radius.circular(40)
                )
            ),
          ),
        );
      },
    );
  }
}