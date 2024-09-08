import 'dart:io';

import 'package:agritechv2/blocs/auth/auth_bloc.dart';
import 'package:agritechv2/blocs/customer/customer_bloc.dart';
import 'package:agritechv2/models/users/Customer.dart';
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Customer? _customer;

  @override
  void initState() {
    super.initState();
    context
        .read<UserRepository>()
        .getCustomer(
          context.read<AuthRepository>().currentUser?.uid ?? "",
        )
        .listen((customer) {
      if (mounted) {
        setState(() {
          _customer = customer;
        });
      }
    });
  }

  void showEditProfileDialog(BuildContext context, String uid, String name) {
    final _formKey = GlobalKey<FormState>();
    String current = name;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    initialValue: name,
                    decoration: const InputDecoration(
                      labelText: 'Enter fullname',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 1,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your fullname';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      current = value;
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Button(
                    onTap: () {
                      context
                          .read<UserRepository>()
                          .editProfile(uid, current)
                          .then((value) => {
                                context.pop(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Successfully updated!")))
                              })
                          .catchError((err) => {
                                context.pop(),
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(err.toString())))
                              });
                    },
                    buttonWidth: double.infinity,
                    buttonText: "Save",
                    buttonColor: ColorStyle.brandRed,
                    borderColor: ColorStyle.blackColor,
                    textColor: Colors.white,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      verticalDirection: VerticalDirection.down,
      children: [
        BlocProvider(
          create: (context) =>
              CustomerBloc(userRepository: context.read<UserRepository>()),
          child: Column(
            children: [
              UserProfile(
                customer: _customer!,
              ),
              Text(
                _customer?.name ?? "",
                style: MyTextStyles.header,
              ),
              Text(
                _customer?.email ?? "",
                style: MyTextStyles.headerlight,
              ),
            ],
          ),
        ),
        const Spacer(),
        SecondaryButton(
            title: "Edit Profile",
            onTap: () {
              if (_customer?.id == null) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text("No user!")));
                return;
              }
              showEditProfileDialog(
                  context, _customer?.id ?? '', _customer?.name ?? '');
            },
            icon: Icons.person_2_outlined),
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
                    _showLogoutConfirmationDialog(context);
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

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context.pop();
                context
                    .read<AuthBloc>()
                    .add(AuthLogoutEvent()); // Trigger logout
              },
              child: const Text("Logout"),
            ),
          ],
        );
      },
    );
  }
}
