import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/view_model/register_body/register_body_cubit.dart';
import 'package:printa/view_model/register_body/register_body_states.dart';

import '../account_otp_verification/verification_success.dart';

class Otp_verify extends StatelessWidget{
  var otpController = TextEditingController();
  FocusNode focusNode1 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
        listener: (context,state){
          if(state is AuthLoggedInState){
            navigateAndFinish(context, verification_success());
          }

      },
        builder: (context,state){
          var cubit=RegisterCubit.get(context);
          return Scaffold(
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
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
                          length: 6, // OTP length is usually 6 digits
                          controller: otpController,
                          focusNode: focusNode1,
                          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                          onCompleted: (pin) {
                            cubit.verifyOTP(pin);
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
                        Text('120'),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Didn’t receive code?'),
                            SizedBox(width: 10),

                          ],
                        ),   SizedBox(height: 50,),

                        defaultMaterialButton(text: 'Submit', Function: (){
                          if (otpController.text.isNotEmpty) {
                            cubit.verifyOTP(otpController.text);
                          } else {
                            showToast(
                              context,
                              title: 'Error',
                              description: 'Please enter the OTP',
                              state: ToastColorState.error,
                              icon: Icons.error,
                            );
                          }

                        }),

                      ]
                  ),
                ),
              )
          );
        },
      ),
    );
  }

}