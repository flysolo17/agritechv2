import 'package:agritechv2/blocs/auth/auth_bloc.dart';
import 'package:agritechv2/models/Customer.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/customer_repository.dart';
import 'package:agritechv2/styles/text_styles.dart';
import 'package:agritechv2/views/reusables/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../styles/color_styles.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    ImageProvider _getProfileImage(String? profileUrl) {
      if (profileUrl != null && profileUrl.isNotEmpty) {
        return NetworkImage(profileUrl);
      } else {
        return const AssetImage(
            'lib/assets/images/offer1.png'); // Replace with actual asset path
      }
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => UserRepository(),
        ),
        RepositoryProvider(
          create: (context) => AuthRepository(),
        ),
      ],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        verticalDirection: VerticalDirection.down,
        children: [
          StreamBuilder<Customer>(
              stream: context
                  .read<UserRepository>()
                  .getCustomer(context.read<AuthRepository>().currentUser!.uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator(); // Loading indicator
                } else if (snapshot.hasError) {
                  return Text('Error: //${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return const Text('No data available.');
                } else {
                  final customer = snapshot.data!;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              // ignore: unnecessary_type_check
                              image: _getProfileImage(customer.profile),
                            ),
                          ),
                        ),
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
                  );
                }
              }),
          const Spacer(),
          BlocConsumer<AuthBloc, AuthState>(
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
          ),
        ],
      ),
    );
  }
}
