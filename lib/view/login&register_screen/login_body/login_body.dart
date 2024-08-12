import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/shared/components/constants.dart';
import 'package:printa/shared/network/local/cache_helper.dart';
import 'package:printa/view/forget_password/forget_password.dart';
import 'package:printa/view/layout/prenta_layout.dart';
import 'package:printa/view/send_email_verification/send_email_verification.dart';
import 'package:printa/view_model/login_body/login_body_cubit.dart';
import 'package:printa/view_model/login_body/login_body_states.dart';
import 'package:printa/view_model/prenta_layout/prenta_cubit.dart';

class LoginBody extends StatelessWidget {
  final bool fromResetPassword;
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  LoginBody({this.fromResetPassword = false});  // Add default value for the flag

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            showToast(
              context,
              title: 'Error',
              description: state.error.toString(),
              state: ToastColorState.error,
              icon: Icons.error,
            );
          }
          if (state is LoginSuccessState) {
            if (FirebaseAuth.instance.currentUser!.emailVerified) {
              CacheHelper.saveData(
                key: 'uId',
                value: state.uId,
              ).then((value) {
                uId=state.uId;
                print('my ID is ################ ${state.uId}');
                print('And This my id in main ########################## ${uId}');
                navigateAndFinish(context, PrentaLayout());
                print('This is user info ${PrentaCubit.get(context).userInfo}');

              });
            } else {
              navigateTo(context, SendEmailVerification());
            }
          }
        },
        builder: (BuildContext context, state) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    defaultTextFormField(
                      controller: emailController,
                      KeyboardType: TextInputType.emailAddress,
                      validate: (value) {
                        if (value!.isEmpty) return 'Please enter your email';
                        else return null;
                      },
                      lable: 'Email',
                      prefix: Ionicons.mail_outline,
                    ),
                    SizedBox(height: 15),
                    defaultTextFormField(
                      controller: passwordController,
                      KeyboardType: TextInputType.visiblePassword,
                      validate: (value) {
                        if (value!.isEmpty) return 'Please type the correct password';
                        else return null;
                      },
                      lable: 'Password',
                      isPassword: LoginCubit.get(context).isPasswordShown,
                      prefix: Ionicons.key_outline,
                      suffix: LoginCubit.get(context).suffixIcon,
                      suffixpressed: () {
                        LoginCubit.get(context).ChangePasswordVisibility();
                      },
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          navigateTo(context, ForgetPassword());
                        },
                        child: Text('Forget Password?'),
                      ),
                    ),
                    SizedBox(height: 30),
                    ConditionalBuilder(
                      condition: (state is! LoginLoadingState),
                      builder: (context) => defaultMaterialButton(
                        text: 'Login',
                        Function: () {
                          if (formKey.currentState!.validate()) {
                            if (fromResetPassword) {
                              LoginCubit.get(context).loginAndUpdatePassword(
                                context,
                                emailController.text,
                                passwordController.text,
                              );
                            } else {
                              LoginCubit.get(context).UserLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          }
                        },
                      ),
                      fallback: (context) => Center(child: CircularProgressIndicator()),
                    ),
                    SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 1,
                          width: 70,
                          color: Colors.blueGrey.withOpacity(0.4),
                        ),
                        SizedBox(width: 10),
                        Text('or login with'),
                        SizedBox(width: 10),
                        Container(
                          height: 1,
                          width: 70,
                          color: Colors.blueGrey.withOpacity(0.4),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.5),
                          width: 0.3,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                      child: MaterialButton(
                        color: Colors.white,
                        height: 60,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        onPressed: () {},
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 37),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image(
                                height: 30,
                                width: 30,
                                image: AssetImage('images/google.png'),
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Google',
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
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