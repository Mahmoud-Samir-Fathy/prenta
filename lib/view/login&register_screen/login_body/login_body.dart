import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';

class LoginBody extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var emailController=TextEditingController();
    var passwordController=TextEditingController();
    return Container(
      child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                defaultTextFormField(
                    controller: emailController,
                    KeyboardType: TextInputType.emailAddress,
                    validate: (value ) {
                      if(value!.isEmpty)
                        return 'Please enter your email';
                      else return null;
                    },
                    lable: 'Email',
                    prefix: Ionicons.mail_outline
                ),SizedBox(height: 15,),
                defaultTextFormField(
                    controller: passwordController,
                    KeyboardType: TextInputType.visiblePassword,
                    validate: (value ) {
                      if(value!.isEmpty)
                        return 'Please type the correct password';
                      else return null;
                    },
                    lable: 'Password',
                    prefix: Ionicons.key_outline,
                    suffix: Ionicons.eye_off_outline,
                ),
                SizedBox(height: 10,),
                Align(
                    alignment:Alignment.centerRight,
                    child: TextButton(onPressed: (){},
                        child: Text('Forget Password?'))),
                SizedBox(height: 30,),
                defaultMaterialButton(text: 'Login', Function: (){}),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 1,
                      width: 70,
                      color: Colors.blueGrey.withOpacity(0.4),
                    ),
                    SizedBox(width: 10,),
                    Text('or login with'),
                    SizedBox(width: 10,),
                    Container(
                      height: 1,
                      width: 70,
                      color: Colors.blueGrey.withOpacity(0.4),
                    ),
                  ],
                ),
            SizedBox(height: 15,),
            Container(
              width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.withOpacity(0.5), // Change this color to the desired border color
                        width: 0.3, // You can adjust the width of the border as needed
                      ),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(
                    Radius.circular(30),

                    ),
                    ),
                    child: MaterialButton(color: Colors.white,

                      height: 60,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all( Radius.circular(30),),
                      ),
                      onPressed: (){},
                      child: Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 37),
                         child: Row(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Image(height:30,width:30,image: AssetImage('images/google.png')),
                             SizedBox(width: 3,),
                             Text('Google',style: TextStyle(fontSize: 18),),
                           ],
                         ),
                    ),)),
                SizedBox(height: 20,)

              ],
            ),
          ),
        ),
    );
  }



}