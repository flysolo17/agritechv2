import 'dart:convert';

import 'package:agritechv2/blocs/auth/auth_bloc.dart';
import 'package:agritechv2/blocs/customer/customer_bloc.dart';
import 'package:agritechv2/models/Address.dart';
import 'package:agritechv2/models/users/Customer.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/customer_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:agritechv2/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AddressesPage extends StatelessWidget {
  final String userID;
  AddressesPage({super.key, required this.userID});
  List<Address> addresses = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorStyle.brandRed,
        title: const Text('My Address'),
      ),
      body: StreamBuilder<Customer>(
          stream: context.read<UserRepository>().getCustomer(userID),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator()); // Loading indicator
            } else if (snapshot.hasError) {
              return Text('Error: //${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Center(child: Text('No data available.'));
            } else {
              final customer = snapshot.data!;
              addresses = customer.addresses;
              return BlocProvider(
                create: (context) => CustomerBloc(
                    userRepository: context.read<UserRepository>()),
                child: SizedBox.expand(
                    child: BlocConsumer<CustomerBloc, CustomerState>(
                  listener: (context, state) {
                    if (state is CustomerSuccess<String>) {
                      print(state.data);
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(state.data)));
                    }
                    if (state is CustomerError) {
                      print(state.message);
                    }
                  },
                  builder: (context, state) {
                    return state is CustomerLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : AddressesList(addresses: addresses);
                  },
                )),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push("/create-address",
              extra: jsonEncode(addresses.map((e) => e.toJson()).toList()));
        }, // Customize the FAB icon
        backgroundColor: ColorStyle.brandRed,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ), // Customize the FAB background color
      ),
    );
  }
}

class AddressesList extends StatelessWidget {
  List<Address> addresses;
  AddressesList({super.key, required this.addresses});

  void _showDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Set Default address'),
          content: const Text(
              'Are you sure you want to change your default address?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Close'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('Set Default'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          CustomerBloc(userRepository: context.read<UserRepository>()),
      child: ListView.builder(
        itemCount: addresses.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              for (int i = 0; i < addresses.length; i++) {
                addresses[i].isDefault = (i == index);
              }
              context.read<CustomerBloc>().add(UpdateAddressDefault(
                  context.read<AuthRepository>().currentUser!.uid, addresses));
            },
            child: AddressContainer(
              address: addresses[index],
            ),
          );
        },
      ),
    );
  }
}

class AddressContainer extends StatelessWidget {
  final Address address;

  AddressContainer({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                truncateText(address.contact.name, 20),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "  | ${address.contact.phone}",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
          Text(
            address.landmark,
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey[400],
                fontSize: 12),
          ),
          Text(
            address.getFormattedLocation(),
            style: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.grey[400],
                fontSize: 12),
          ),
          if (address.isDefault)
            Container(
              margin: const EdgeInsets.all(10.0),
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: ColorStyle.brandRed,
                  width: 1.0, // Border width
                ),
                borderRadius: BorderRadius.circular(3.0),
              ),
              child: const Text(
                "Default",
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: ColorStyle.brandRed,
                  fontSize: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
