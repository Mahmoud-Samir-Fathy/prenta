import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/view_model/login_body/login_body_cubit.dart';
import 'package:printa/view_model/login_body/login_body_states.dart';

class ForgetPassword extends StatelessWidget {
  var emailController = TextEditingController();

  ForgetPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Reset Password',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      'Enter your registered email below so we can send an email to reset your password',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                    ),
                    const SizedBox(height: 25),
                    defaultTextFormField(
                      controller: emailController,
                      KeyboardType: TextInputType.emailAddress,
                      validate: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email';
                        } else {
                          return null;
                        }
                      },
                      lable: 'Email Address',
                      prefix: Ionicons.mail_outline,
                    ),
                    const SizedBox(height: 25),
                    const Center(child: Image(image: AssetImage('images/change_password.png'))),
                    const SizedBox(height: 40),
                    Center(
                      child: defaultMaterialButton(
                        text: 'Send',
                        Function: () {
                          LoginCubit.get(context).resetPassword(
                            context: context,
                            email: emailController.text.trim(),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
