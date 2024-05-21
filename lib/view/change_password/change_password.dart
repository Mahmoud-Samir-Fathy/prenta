import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printa/shared/styles/colors.dart';
import '../../shared/components/components.dart';

class change_password extends StatelessWidget{
  var oldPasswordController=TextEditingController();
  var newPasswordController=TextEditingController();
  var confirmNewPasswordController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: thirdColor,
      appBar: AppBar(
        backgroundColor: thirdColor,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios),onPressed: (){},),
        title: Text('Change Password'),
        centerTitle:true ,
      ),
      body: Container(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
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
                    } else {
                      return null;
                    }
                  },
                  lable: 'Current Password',
                  prefix: Icons.password,
                  suffix: Icons.visibility_off
                ),
                SizedBox(height: 8,),
                Align(alignment: AlignmentDirectional.bottomEnd,
                    child: TextButton(onPressed: (){}, child: Text('Forget Password?'))),
                SizedBox(height: 15,),
                Text('New Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                defaultTextFormField(
                  controller: confirmNewPasswordController,
                  KeyboardType: TextInputType.visiblePassword,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your new password';
                    } else {
                      return null;
                    }
                  },
                  lable: 'New Password',
                  prefix: Icons.password,
                  suffix: Icons.visibility_off
                ),
                SizedBox(height: 15,),
                Text('Confirm Password', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
                SizedBox(height: 8),
                defaultTextFormField(
                  controller: confirmNewPasswordController,
                  KeyboardType: TextInputType.visiblePassword,
                  validate: (value) {
                    if (value!.isEmpty) {
                      return 'Your password isn\'t identical';
                    } else {
                      return null;
                    }
                  },
                  lable: 'Confirm password',
                  prefix: Icons.password,
                  suffix: Icons.visibility_off
                ),

                SizedBox(height: 40,),
                Center(child: defaultMaterialButton(text: 'Submit', Function: (){}))
              ],
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
  }
}