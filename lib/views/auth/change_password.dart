import 'package:agritechv2/blocs/auth/auth_bloc.dart';
import 'package:agritechv2/repository/customer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../repository/auth_repository.dart';
import '../../styles/color_styles.dart';
import '../custom widgets/button.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        title: const Text(
          "Change Password",
          style: TextStyle(
              fontWeight: FontWeight.w400, fontSize: 16, color: Colors.white),
        ),
        backgroundColor: ColorStyle.brandRed,
      ),
      body: SingleChildScrollView(
        child: BlocProvider(
          create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
              userRepository: context.read<UserRepository>()),
          child: const ChangePasswordForm(),
        ),
      ),
    );
  }
}

class ChangePasswordForm extends StatefulWidget {
  const ChangePasswordForm({super.key});

  @override
  _ChangePasswordFormState createState() => _ChangePasswordFormState();
}

class _ChangePasswordFormState extends State<ChangePasswordForm> {
  final _formKey = GlobalKey<FormState>();
  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: SvgPicture.asset(
                'assets/svgs/change_password.svg',
                height: 200,
              ),
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Current Password is required';
                }
                // Add your validation logic here if needed.
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _currentPassword = value;
                });
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'New Password is required';
                } else if (value.length < 6) {
                  return 'New Password must be at least 6 characters long';
                }
                // Add your validation logic here if needed.
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _newPassword = value;
                });
              },
            ),
            TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Confirm Password is required';
                } else if (value != _newPassword) {
                  return 'Passwords do not match';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _confirmPassword = value;
                });
              },
            ),
            const SizedBox(
              height: 20.0,
            ),
            BlocConsumer<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is AuthFailedState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.errorMessage)),
                  );
                }
                if (state is AuthSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.data)),
                  );
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
                            if (_formKey.currentState!.validate()) {
                              context.read<AuthBloc>().add(ReauthenticateUser(
                                  _currentPassword, _newPassword));
                            }
                          },
                          buttonWidth: double.infinity,
                          buttonText: "Forgot Password",
                          buttonColor: ColorStyle.brandRed,
                          borderColor: ColorStyle.blackColor,
                          textColor: ColorStyle.whiteColor,
                        ),
                      );
              },
            ),
          ],
        ),
      ),
    );
  }
}
