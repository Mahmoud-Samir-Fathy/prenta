import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:pinput/pinput.dart';
import 'dart:async'; // Import the dart:async package for Timer
import 'OTP Bloc.dart';
import 'OTP Event.dart';
import 'OTP State.dart';

class OtpVerification extends StatefulWidget {
  final String phoneNumber; // Add a phoneNumber parameter

  OtpVerification({required this.phoneNumber}); // Update the constructor

  @override
  _OtpVerificationState createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  var otpController = TextEditingController();
  FocusNode focusNode1 = FocusNode();
  int _start = 120;
  late Timer _timer;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _isButtonDisabled = true;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _isButtonDisabled = false;
        });
        timer.cancel();
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => OtpBloc(),
        child: Center(
          child: SingleChildScrollView(
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
                    Text(widget.phoneNumber, style: TextStyle(fontWeight: FontWeight.w700)),
                  ],
                ),
                SizedBox(height: 15),
                Pinput(
                  length: 6, // OTP length is usually 6 digits
                  controller: otpController,
                  focusNode: focusNode1,
                  pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                  onCompleted: (pin) {
                    BlocProvider.of<OtpBloc>(context).add(VerifyOtpEvent(pin));
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
                    TextButton(
                      onPressed: _isButtonDisabled
                          ? null
                          : () {
                        setState(() {
                          _start = 120; // Reset the timer
                        });
                        _startTimer();
                        BlocProvider.of<OtpBloc>(context).add(SendOtpEvent(widget.phoneNumber));
                      },
                      child: Text('Re-send', style: TextStyle(color: _isButtonDisabled ? Colors.grey : Colors.black)),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                BlocConsumer<OtpBloc, OtpState>(
                  listener: (context, state) {
                    if (state is OtpVerified) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('OTP Verified Successfully!')),
                      );
                    } else if (state is OtpError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.message}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is OtpLoading) {
                      return CircularProgressIndicator();
                    }
                    return ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<OtpBloc>(context).add(VerifyOtpEvent(otpController.text));
                      },
                      child: Text('Submit'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
