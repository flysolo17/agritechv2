import 'package:agritechv2/views/custom%20widgets/button.dart';
import 'package:agritechv2/views/custom%20widgets/input_field.dart';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/auth/auth_bloc.dart';
import '../../styles/color_styles.dart';
import '../../styles/text_styles.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _firstNameController = TextEditingController();

  final TextEditingController _lastNameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // SignUpController signUpController = Get.put(SignUpController());
  bool passwordIsHidden = true;
  hideThePassword() {
    setState(() {
      passwordIsHidden = !passwordIsHidden;
    });
  }

  bool _isChecked1 = false;
  final bool _isChecked2 = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.background,
      body: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 33.0),
            child: Column(
              children: [
                const SizedBox(height: 80),
                GestureDetector(
                  onTap: () {},
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                        height: 33,
                        width: 33,
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: ColorStyle.blackColor,
                            )),
                        child: SvgPicture.asset(
                            "lib/assets/svg_icons/Light/Arrow - Left.svg")),
                  ),
                ),
                const SizedBox(height: 40),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "REGISTER",
                          style: MyTextStyles.header,
                        ),
                        Text(
                          "Create your Agritech account",
                          style: MyTextStyles.headerlight.copyWith(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 62),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Text(
                          "*",
                          style: MyTextStyles.text.copyWith(
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          "Required",
                          style: MyTextStyles.text,
                        ),
                      ],
                    )),
                const SizedBox(height: 5),
                InputField(
                  hasTitle: false,
                  hintText: "Firstname",
                  controller: _firstNameController,
                ),
                InputField(
                  hasTitle: false,
                  hintText: "Lastname",
                  controller: _lastNameController,
                ),
                InputField(
                  isEmail: true,
                  hasTitle: false,
                  hintText: "Email",
                  controller: _emailController,
                ),
                InputField(
                  hasTitle: false,
                  hintText: "Phone",
                  inputType: TextInputType.phone,
                  controller: _phoneController,
                ),
                InputField(
                  controller: _passwordController,
                  hasSuffix: true,
                  isObsured: passwordIsHidden,
                  suffixIcon: GestureDetector(
                    onTap: hideThePassword,
                    child: passwordIsHidden
                        ? const Icon(
                            Icons.visibility,
                            color: ColorStyle.blackColor,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            color: ColorStyle.blackColor,
                          ),
                  ),
                  hasTitle: false,
                  hintText: "Password",
                ),
                InputField(
                  controller: _confirmPasswordController,
                  hasSuffix: true,
                  isObsured: passwordIsHidden,
                  suffixIcon: GestureDetector(
                    onTap: hideThePassword,
                    child: passwordIsHidden
                        ? const Icon(
                            Icons.visibility,
                            color: ColorStyle.blackColor,
                          )
                        : const Icon(
                            Icons.visibility_off,
                            color: ColorStyle.blackColor,
                          ),
                  ),
                  hasTitle: false,
                  hintText: "Confirm Password",
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    SizedBox(
                      height: 60,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Checkbox(
                          value: _isChecked1,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked1 = value ?? false;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.push('/terms');
                            },
                            child: Text(
                              "I hereby agree to the Program Mechanics and Terms",
                              style: MyTextStyles.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      height: 105,
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: Checkbox(
                          value: _isChecked1,
                          onChanged: (bool? value) {
                            setState(() {
                              _isChecked1 = value ?? false;
                            });
                          },
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => {context.push('/terms')},
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          "I hereby agree that all information I provided here can be processed and used by Agritech in accourdance with their Privacy Policy",
                          style: MyTextStyles.text,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                BlocListener<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthFailedState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)));
                    }
                    if (state is AuthSaveUserState) {
                      context
                          .read<AuthBloc>()
                          .add(AuthSavingUserEvent(state.user, state.users));
                    }
                    if (state is AuthSuccessState) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('New User added!')));
                    }
                    if (state is AuthenticatedState) {
                      context.go('/');
                    }
                    if (state is AuthenticatedButNotVerified) {
                      context.go("/verification");
                    }
                  },
                  child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return state is AuthLoadingState
                          ? const Center(child: CircularProgressIndicator())
                          : Button(
                              onTap: () async {
                                String email = _emailController.text.toString();
                                String password =
                                    _passwordController.text.toString();
                                String phone = _phoneController.text.toString();
                                String confirmPassword =
                                    _passwordController.text.toString();
                                String first =
                                    _firstNameController.text.toString();
                                String last =
                                    _lastNameController.text.toString();
                                if (email.isNotEmpty &&
                                    (password == confirmPassword)) {
                                  print('Signing click....');
                                  context.read<AuthBloc>().add(AuthSignUpEvent(
                                      '$first $last', phone, email, password));
                                }
                              },
                              buttonWidth: double.infinity,
                              buttonText: "Next",
                              buttonColor: ColorStyle.brandRed,
                              borderColor: ColorStyle.blackColor,
                              textColor: ColorStyle.whiteColor,
                            );
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
