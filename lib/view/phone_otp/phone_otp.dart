import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';
import 'package:printa/shared/components/components.dart';

class Otp_verify extends StatelessWidget{
  var otpController = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  int _start = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        child: Column(
            children: [
            Image(image: AssetImage('images/for_otp.png')),
            SizedBox(height: 20),
            Text('OTP VERIFICATION', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Enter the OTP sent to - '),
                Text('01150324699', style: TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
            SizedBox(height: 15),
            Pinput(
              length: 4, // OTP length is usually 6 digits
              controller: otpController,
              focusNode: focusNode1,
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              onCompleted: (pin) {
              },
              pinAnimationType: PinAnimationType.rotation,
              defaultPinTheme: PinTheme(
                width: 70,
                height: 70,
                textStyle: TextStyle(fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
                decoration: BoxDecoration(
                  border: Border.all(color: HexColor('C5BEBE'), width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 15),
           Text('00:${_start.toString().padLeft(2, '0')} Sec'),
           SizedBox(height: 15),
             Row(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
               Text('Didn’t receive code?'),
                 SizedBox(width: 10),
        
            ],
        ),   SizedBox(height: 50,),

              defaultMaterialButton(text: 'Submit', Function: (){}),

          ]
        ),
      )
    );
  }

}