import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:printa/shared/components/components.dart';

class Change_password extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var newPassword=TextEditingController();
    var confirmNewPassword=TextEditingController();

    return Scaffold(
      appBar: AppBar(),
     body: Padding(
       padding: const EdgeInsets.symmetric(horizontal: 10.0),
       child: SingleChildScrollView(
         child: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Text('Change New Password',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
             SizedBox(height: 15,),
             Text('Enter your registered email below',style: TextStyle(color: Colors.grey,fontSize: 16),),
             SizedBox(height: 25,),
             defaultTextFormField(
                 controller: newPassword,
                 KeyboardType: TextInputType.text,
                 validate: (value){
                   if(value!.isEmpty){
                     return 'Please enter a new password';
                   }
                   else{
                     return null;
                   }
                 },
                 lable: 'New Password',
                 prefix:  Icons.lock_clock_outlined,
                 suffix: Icons.visibility_off
             ),
             SizedBox(height: 20,),
             defaultTextFormField(
                 controller: confirmNewPassword,
                 KeyboardType: TextInputType.text,
                 validate: (value){
                if(value!.isEmpty){
              return 'Please enter a new password';
               }
               else{
                    return null;
                       }
                 },
                 lable: 'Confirm Password',
                 prefix:  Icons.lock_clock_outlined,
             suffix: Icons.visibility_off
             ),
         
             SizedBox(height: 25,),
             Center(child: Image(image: AssetImage('images/change_password.png'))),
             SizedBox(height: 40,),
             Center(child: defaultMaterialButton(text: 'Continue', Function: (){})),
           ],
         ),
       ),
     ),
   );
  }

}