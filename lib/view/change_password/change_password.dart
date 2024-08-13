import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/constants.dart';
import 'package:printa/shared/styles/colors.dart';
import 'package:printa/view/forget_password/forget_password_in_edit.dart';
import 'package:printa/view/user_profile/profile.dart';
import 'package:printa/view_model/change_mode/mode_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';
import 'package:printa/view_model/prenta_layout/prenta_states.dart';
import '../../shared/components/components.dart';

class ChangePassword extends StatelessWidget{
  var oldPasswordController=TextEditingController();
  var newPasswordController=TextEditingController();
  var confirmNewPasswordController=TextEditingController();
  var formKey=GlobalKey<FormState>();

  ChangePassword({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PrentaCubit,PrentaStates>(

      listener: (context,state){
        if (state is UpdateUserInfoSuccessState) {
          navigateTo(context, Profile());
          showToast(context, title: 'Success', description: 'Password has been updated', state: ToastColorState.success, icon: Ionicons.thumbs_up_outline);
          PrentaCubit.get(context).sendPushMessage(deviceToken!, 'Password has been updated successfully', 'Password Updated', DateTime.now().toString(), 'password');
        } else if (state is UpdateUserInfoErrorState) {
          showToast(context, title: 'Error', description: 'Failed to update password', state: ToastColorState.error, icon: Ionicons.alert_circle_outline);
        }
      },
      builder:(context,state){
        var cubit=PrentaCubit.get(context);
        var mCubit=ModeCubit.get(context);
        return  Scaffold(
          backgroundColor: mCubit.isDark?secondColor:thirdColor,
          appBar: AppBar(
            backgroundColor:  mCubit.isDark?secondColor:thirdColor,
            leading: IconButton(icon: const Icon(Ionicons.chevron_back_outline),onPressed: (){
              Navigator.pop(context);
            },),
            title: const Text('Change Password'),
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
                      const Text('Current Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500,)),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 8,),
                      Align(alignment: AlignmentDirectional.bottomEnd,
                          child: TextButton(onPressed: (){
                            navigateTo(context, Reset_password_in_edit());
                          }, child: Text('Forget Password?',style: TextStyle(color: mCubit.isDark?Colors.white:Colors.blueAccent),))),
                      const SizedBox(height: 15,),
                      const Text('New Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
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
                      const SizedBox(height: 15,),
                      const Text('Confirm Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                      const SizedBox(height: 8),
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

                      const SizedBox(height: 40,),
                      Center(
                          child: defaultMaterialButton(text: 'Submit', Function: ()
                      {
                        if (formKey.currentState!.validate()) {
                          cubit.updateUserPassword(email: cubit.userInfo!.email.toString(), currentPassword: oldPasswordController.text, newPassword: newPasswordController.text);

                        }
                      }))
                    ],
                  ),
                ),
              ),
            ),
            decoration: BoxDecoration(
                color: mCubit.isDark?Colors.grey[700]:Colors.white,
                borderRadius: const BorderRadius.only(
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