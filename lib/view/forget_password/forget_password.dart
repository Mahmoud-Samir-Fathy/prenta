import 'package:flutter/material.dart';
import 'package:printa/shared/components/components.dart';

class forget_password extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var forgetPasswordController=TextEditingController();
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(image:AssetImage('images/forget_password.png')),
                SizedBox(height: 25,),
                Text('Forget \nPassword?',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                SizedBox(height: 25,),
                Text('Don’t worry ! It happens. Please enter Email address we will send the OTP in this Email address.'),
                SizedBox(height: 40,),
                defaultTextFormField(
                    controller: forgetPasswordController,
                    KeyboardType: TextInputType.emailAddress,
                    validate: (value){
                      if(value!.isEmpty){
                        return 'Please Enter your email address';
                      }else return null;
                    },
                    lable: 'Enter the Email address',
                    prefix: Icons.email),
                SizedBox(height: 40,),
                    Center(
                      child: defaultMaterialButton(text: 'Continue', Function: (){}),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}