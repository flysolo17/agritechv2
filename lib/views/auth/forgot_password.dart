import 'package:agritechv2/blocs/auth/auth_bloc.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/customer_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../custom widgets/button.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController _emailController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Forgot Password",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: ColorStyle.brandRed,
      ),
      body: BlocProvider(
        create: (context) => AuthBloc(
            authRepository: context.read<AuthRepository>(),
            userRepository: context.read<UserRepository>()),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: SvgPicture.asset(
                  'lib/assets/svg_icons/forgot.svg',
                  height: 180,
                ),
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              const Spacer(),
              BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  print(state);
                  if (state is AuthFailedState) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.errorMessage)));
                  }
                  if (state is AuthSuccessState<String>) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(state.data)));
                    context.pop();
                  }
                },
                builder: (context, state) {
                  return state is AuthLoadingState
                      ? const Center(
                          child: CircularProgressIndicator(),
                        )
                      : Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: Button(
                            onTap: () async {
                              var email = _emailController.text;
                              context
                                  .read<AuthBloc>()
                                  .add(ForgotPassword(email));
                            },
                            buttonWidth: double.infinity,
                            buttonText: "Forgot Password",
                            buttonColor: ColorStyle.brandRed,
                            borderColor: ColorStyle.blackColor,
                            textColor: ColorStyle.whiteColor,
                          ),
                        );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
