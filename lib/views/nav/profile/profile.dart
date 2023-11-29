import 'dart:io';

import 'package:agritechv2/blocs/auth/auth_bloc.dart';
import 'package:agritechv2/blocs/customer/customer_bloc.dart';
import 'package:agritechv2/models/Customer.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/customer_repository.dart';
import 'package:agritechv2/styles/text_styles.dart';
import 'package:agritechv2/views/custom%20widgets/button.dart';
import 'package:agritechv2/views/custom%20widgets/secondary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../styles/color_styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      children: [
        StreamBuilder<Customer>(
            stream: context.read<UserRepository>().getCustomer(
                context.read<AuthRepository>().currentUser?.uid ?? ""),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator(); // Loading indicator
              } else if (snapshot.hasError) {
                return Text('Error: //${snapshot.error}');
              } else if (!snapshot.hasData) {
                return const Text('No data available.');
              } else {
                final customer = snapshot.data!;
                return BlocProvider(
                  create: (context) => CustomerBloc(
                      userRepository: context.read<UserRepository>()),
                  child: Column(
                    children: [
                      UserProfile(
                        customer: customer,
                      ),
                      Text(
                        customer.name,
                        style: MyTextStyles.header,
                      ),
                      Text(
                        customer.email,
                        style: MyTextStyles.headerlight,
                      ),
                    ],
                  ),
                );
              }
            }),
        const Spacer(),
        SecondaryButton(
            title: "Edit Profile", onTap: () {}, icon: Icons.person_2_outlined),
        SecondaryButton(
            title: "Change Password",
            onTap: () => context.push('/change-password'),
            icon: Icons.password_outlined),
        SecondaryButton(
            title: "Addresses",
            onTap: () => context.push(
                '/address/${context.read<AuthRepository>().currentUser?.uid}'),
            icon: Icons.location_city_outlined),
        const LogoutButton()
      ],
    );
  }
}

ImageProvider _getProfileImage(String? profileUrl) {
  if (profileUrl != null && profileUrl.isNotEmpty) {
    return NetworkImage(profileUrl);
  } else {
    return const AssetImage(
        'lib/assets/images/offer1.png'); // Replace with actual asset path
  }
}

class UserProfile extends StatefulWidget {
  final Customer customer;
  const UserProfile({super.key, required this.customer});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image != null) {
          File file = File(image.path);
          setState(() {
            context
                .read<CustomerBloc>()
                .add(UploadUserPhoto(widget.customer.id, file));
          });
        } else {
          print('create quiz page : error picking image');
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              fit: BoxFit.cover,
              // ignore: unnecessary_type_check
              image: _getProfileImage(widget.customer.profile),
            ),
          ),
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is UnAthenticatedState) {
          print("Logged out!");
          context.go('/login');
        }
      },
      builder: (context, state) {
        return state is AuthLoadingState
            ? const CircularProgressIndicator()
            : Padding(
                padding: const EdgeInsets.all(10),
                child: Button(
                  onTap: () {
                    context.read<AuthBloc>().add(AuthLogoutEvent());
                  },
                  buttonWidth: double.infinity,
                  buttonText: "Logout",
                  buttonColor: ColorStyle.brandRed,
                  borderColor: ColorStyle.blackColor,
                  textColor: Colors.white,
                ),
              );
      },
    );
  }
}
