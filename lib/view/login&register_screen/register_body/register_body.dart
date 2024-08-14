import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:printa/shared/components/components.dart';
import 'package:printa/view/send_email_verification/send_email_verification.dart';
import 'package:printa/view_model/register_body/register_body_cubit.dart';
import 'package:printa/view_model/register_body/register_body_states.dart';


class RegisterBody extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  RegisterBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) =>RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if(state is CreateUserSuccessState){
            navigateTo(context, const SendEmailVerification());
          }else if (state is CreateUserErrorState){
            showToast(context, title: 'Error', description: state.error, state: ToastColorState.error, icon: Ionicons.warning);
          }
        },
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
                                const SizedBox(height: 8),
                                defaultTextFormField(
                                  controller: firstNameController,
                                  keyboardType: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your first name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  label: 'First Name',
                                  prefix: Icons.person_outline,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                defaultTextFormField(
                                  controller: lastNameController,
                                  keyboardType: TextInputType.text,
                                  validate: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your Last name';
                                    } else {
                                      return null;
                                    }
                                  },
                                  label: 'Last Name',
                                  prefix: Icons.person_outline,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15),
                      defaultTextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your phone';
                          } else {
                            return null;
                          }
                        },
                        label: 'Phone Number',
                        prefix: Ionicons.phone_portrait_outline,
                      ),
                      const SizedBox(height: 15),
                      defaultTextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.text,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          } else {
                            return null;
                          }
                        },
                        label: 'Email',
                        prefix: Ionicons.mail_outline,
                      ),
                      const SizedBox(height: 15),
                      defaultTextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please type the correct password';
                          } else {
                            return null;
                          }
                        },
                        label: 'Password',
                        prefix: Ionicons.key_outline,
                        isPassword: RegisterCubit.get(context).isPasswordShown,
                        suffix: RegisterCubit.get(context).suffixIcon,
                        suffixpressed: () {
                          RegisterCubit.get(context).changePasswordVisibility();
                        },
                      ),
                      const SizedBox(height: 15),
                      defaultTextFormField(
                        controller: confirmPasswordController,
                        keyboardType: TextInputType.visiblePassword,
                        validate: (value) {
                          if (value!.isEmpty) {
                            return 'Please type the correct password';
                          } else if (value != passwordController.text) {
                            return 'Passwords do not match';
                          } else {
                            return null;
                          }
                        },
                        label: 'Confirm Password',
                        isPassword: RegisterCubit.get(context).isPasswordShown,
                        prefix: Ionicons.key_outline,
                        suffix: RegisterCubit.get(context).suffixIcon,
                        suffixpressed: () {
                          RegisterCubit.get(context).changePasswordVisibility();
                        },
                      ),
                      const SizedBox(height: 30),
                      ConditionalBuilder(
                        condition: (state is! RegisterLoadingState),
                        builder: (context) => defaultMaterialButton(
                          text: 'Register',
                          function: () {
                            if (formKey.currentState!.validate()) {
                              RegisterCubit.get(context).userRegister(
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                phoneNumber: phoneController.text, // Ensure phone number is an int
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                        ),
                        fallback: (context) => const Center(child: CircularProgressIndicator()),
                      ),
                      const SizedBox(height: 40),
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
