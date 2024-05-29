import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/view/layout/prenta_layout.dart';
import 'package:printa/view_model/register_body/register_body_cubit.dart';
import 'package:printa/view_model/register_body/register_body_states.dart';

class RegisterBody extends StatelessWidget {
  var formKey = GlobalKey<FormState>();

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var phoneController = TextEditingController();
  var confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
           if(state is CreateUserSuccessState){
             navigateAndFinish(context, prenta_layout());
        }},
        builder: (context, state) {
          return Container(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                defaultTextFormField(
                                  controller: firstNameController,
                                  KeyboardType: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your first name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  lable: 'First Name',
                                  prefix: Icons.person_outline,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                defaultTextFormField(
                                  controller: lastNameController,
                                  KeyboardType: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Last name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  lable: 'Last Name',
                                  prefix: Icons.person_outline,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      defaultTextFormField(
                        controller: phoneController,
                        KeyboardType: TextInputType.phone,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone';
                          } else {
                            return null;
                          }
                        },
                        lable: 'Phone Number',
                        prefix: Ionicons.phone_portrait_outline,
                      ),
                      SizedBox(height: 15),
                      defaultTextFormField(
                        controller: emailController,
                        KeyboardType: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else {
                            return null;
                          }
                        },
                        lable: 'Email',
                        prefix: Ionicons.mail_outline,
                      ),
                      SizedBox(height: 15),
                      defaultTextFormField(
                        controller: passwordController,
                        KeyboardType: TextInputType.visiblePassword,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please type the correct password';
                          } else {
                            return null;
                          }
                        },
                        lable: 'Password',
                        prefix: Ionicons.key_outline,
                        isPassword: RegisterCubit.get(context).isPasswordShown,
                        suffix: RegisterCubit.get(context).suffixIcon,
                        suffixpressed: () {
                          RegisterCubit.get(context).ChangePasswordVisibility();
                        },
                      ),
                      SizedBox(height: 15),
                      defaultTextFormField(
                        controller: confirmPasswordController,
                        KeyboardType: TextInputType.visiblePassword,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please type the correct password';
                          } else if (value != passwordController.text) {
                            return 'Passwords do not match';
                          } else {
                            return null;
                          }
                        },
                        lable: 'Confirm Password',
                        isPassword: RegisterCubit.get(context).isPasswordShown,
                        prefix: Ionicons.key_outline,
                        suffix: RegisterCubit.get(context).suffixIcon,
                        suffixpressed: () {
                          RegisterCubit.get(context).ChangePasswordVisibility();
                        },
                      ),
                      SizedBox(height: 30),
                      ConditionalBuilder(
                        condition: (state is! RegisterLoadingState),
                        builder: (context) => defaultMaterialButton(
                          text: 'Register',
                          Function: () {
                            if (formKey.currentState!.validate()) {
                              RegisterCubit.get(context).userRegister(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                phoneNumber: phoneController.hashCode,
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
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
                          Text('or Register with'),
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
                            borderRadius:
                            BorderRadius.all(Radius.circular(30)),
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
            ),
          );
        },
      ),
    );
  }
}
