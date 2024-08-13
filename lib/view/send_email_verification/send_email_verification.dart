import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';

class SendEmailVerification extends StatelessWidget{
  const SendEmailVerification({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(child: Image(image: AssetImage('images/success.png'))),
            const SizedBox(height: 30,),
            const Text('To enjoy our services, we need to just verify your email address',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
            const Text('so please press send button to ensure thats you',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold)),
            const Spacer(),
            defaultMaterialButton(text: 'Send', Function: (){
              FirebaseAuth.instance.currentUser!.sendEmailVerification();
              showToast(context, title: 'Sent', description: 'An email was send to your email address please check it', state: ToastColorState.success, icon:Ionicons.thumbs_up_outline);
            }),
            const SizedBox(height: 30,),
          ],
        ),
      ),
    );
  }
}