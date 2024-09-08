import 'package:agritechv2/models/users/Users.dart';
import 'package:agritechv2/repository/message_repository.dart';
import 'package:agritechv2/utils/Constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserPages extends StatelessWidget {
  void Function(Users users) onUserClicked;
  UserPages({super.key, required this.onUserClicked});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Users>>(
      future: context.read<MessagesRepository>().getAllUsers(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Users> users = snapshot.data ?? [];

          return SizedBox(
            width: double.infinity,
            height: 150,
            child: ListView.builder(
              itemCount: users.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final user = users[index];
                return GestureDetector(
                  onTap: () => onUserClicked(user),
                  child: Container(
                    width: 100,
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: const BoxDecoration(),
                          child: user.profile.isEmpty
                              ? ClipOval(
                                  child: Image.asset(
                                    'lib/assets/images/profile_placeholder.jpg', // Replace with the actual image path
                                    fit: BoxFit
                                        .cover, // Adjust the fit as needed
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage(
                                    user.profile,
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 8.0,
                        ),
                        Text(user.name,
                            overflow: TextOverflow.ellipsis, maxLines: 1)
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          return usersShimer();
        }
      },
    );
  }
}
