import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';
import 'package:printa/shared/components/components.dart';

class otp_verification extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var otpController = TextEditingController();
    FocusNode focusNode1 = FocusNode();
    return Scaffold(
      body:Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image(image: AssetImage('images/for_otp.png')),
              SizedBox(height: 20,),
              Text('OTP VERIFICATION',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Enter the OTP sent to - '),
                  Text('+91-8976500001',style: TextStyle(fontWeight: FontWeight.w700),)
                ],
              ),
              SizedBox(height: 15,),
              Pinput(
                length: 4,
                controller: otpController,
                focusNode: focusNode1,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                onCompleted: (
                    pin) {
                  print(
                      'Completed: $pin');
                },
                onSubmitted: (
                    pin) {
                },
                pinAnimationType: PinAnimationType.rotation,
                defaultPinTheme: PinTheme(
                  width: 70,
                  height: 70,
                  textStyle: TextStyle(
                      fontSize: 24,
                      color: Colors.black,
                      fontWeight: FontWeight.bold ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: HexColor('C5BEBE'), width:1.5),
                    borderRadius: BorderRadius.circular(12), // Circular shape with half width/height as radius
                  ),
                ),),
              SizedBox(height: 15,),
              Text('00:120 Sec'),
              SizedBox(height: 15,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don’t receive code ?'),
                  SizedBox(height: 10,),
                  TextButton(onPressed: (){}, child: Text('Re-send',style: TextStyle(color: Colors.black),)),
                ],
              ),
              SizedBox(height: 15,),
              defaultMaterialButton(text: 'Submit', Function: (){}),

            ],
          ),
        ),
      ),
    );
  }
}