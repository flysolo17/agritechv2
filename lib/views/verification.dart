import 'dart:async';

import 'package:agritechv2/blocs/auth/auth_bloc.dart';
import 'package:agritechv2/views/custom%20widgets/button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../styles/color_styles.dart';
import '../styles/text_styles.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({super.key});

  @override
  State<VerificationPage> createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  late Timer _timer;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      auth.currentUser?.reload();
      if (auth.currentUser!.emailVerified) {
        _timer.cancel();
      }
      print("Changed ${auth.currentUser?.emailVerified}");
      context.read<AuthBloc>().add(AuthUserChanged(auth.currentUser));
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
      backgroundColor: ColorStyle.background,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 33.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "lib/assets/images/authPageImage.png",
                  height: 87,
                  width: 94,
                ),
                const SizedBox(height: 27),
                Text(
                  "Verify Gmail Account",
                  style: MyTextStyles.header,
                ),
                const SizedBox(height: 21),
                Text(
                  "Enter the verification code we just sent you on your provided gmail account",
                  style: MyTextStyles.text.copyWith(color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 21),
                const SizedBox(height: 40),
                BlocConsumer<AuthBloc, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSuccessState<User>) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Email sent to ${state.data.email}')));
                    }
                    if (state is UnAthenticatedState) {
                      context.go('/login');
                    }
                    if (state is AuthenticatedButNotVerified) {
                      context.go('/verification');
                    }
                    if (state is AuthenticatedState) {
                      context.go('/');
                    }
                  },
                  builder: (context, state) {
                    if (state is AuthSuccessState<User> &&
                        state.data.emailVerified) {
                      context.go('/');
                    }
                    return state is AuthLoadingState
                        ? const CircularProgressIndicator()
                        : Button(
                            onTap: () async {
                              context
                                  .read<AuthBloc>()
                                  .add(const AuthSendEmailVerification());
                            },
                            buttonWidth: double.infinity,
                            buttonText: "Verify",
                            buttonColor: ColorStyle.brandRed,
                            borderColor: ColorStyle.blackColor,
                            textColor: ColorStyle.whiteColor,
                          );
                  },
                ),
                const SizedBox(height: 21),
                TextButton(
                    onPressed: () =>
                        context.read<AuthBloc>().add(AuthLogoutEvent()),
                    child: const Text('Logout'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
