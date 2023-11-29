import 'package:agritechv2/blocs/auth/auth_bloc.dart';
import 'package:agritechv2/views/custom%20widgets/button.dart';
import 'package:agritechv2/views/custom%20widgets/input_field.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../styles/color_styles.dart';
import '../../styles/text_styles.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordIsHidden = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  hideThePassword() {
    setState(() {
      passwordIsHidden = !passwordIsHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorStyle.background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Image.asset(
                    "lib/assets/images/logo.png",
                    height: 130,
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: SizedBox(
                            width: 200,
                            child: Text(
                              "Login with your Agritech Account",
                              style: MyTextStyles.header,
                            ),
                          ),
                        ),
                        InputField(
                          hasTitle: false,
                          hintText: "Email",
                          controller: _emailController,
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
                        BlocListener<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is AuthFailedState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.errorMessage)));
                            }
                            if (state is AuthSuccessState) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Successfully logged in')));
                            }
                            if (state is AuthenticatedState) {
                              context.go('/');
                            }
                            if (state is AuthenticatedButNotVerified) {
                              context.go('/verification');
                            }
                          },
                          child: BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return state is AuthLoadingState
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12.0),
                                      child: Button(
                                        onTap: () async {
                                          var email = _emailController.text;
                                          var password =
                                              _passwordController.text;
                                          print('$email $password');
                                          context.read<AuthBloc>().add(
                                              AuthSignInEvent(email, password));
                                        },
                                        buttonWidth: double.infinity,
                                        buttonText: "Login",
                                        buttonColor: ColorStyle.brandRed,
                                        borderColor: ColorStyle.blackColor,
                                        textColor: ColorStyle.whiteColor,
                                      ),
                                    );
                            },
                          ),
                        ),
                        TextButton(
                          onPressed: () => context.push('/forgot-password'),
                          child: const Text("Forgot Password"),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Don’t have an account?",
                    style: MyTextStyles.text,
                  ),
                ),
                Button(
                  onTap: () {
                    context.push('/signup');
                  },
                  buttonWidth: double.infinity,
                  buttonText: "Register here",
                  buttonColor: Colors.transparent,
                  borderColor: ColorStyle.blackColor,
                  textColor: ColorStyle.blackColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
