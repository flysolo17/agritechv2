import 'package:agritechv2/blocs/messenger/messenger_bloc.dart';
import 'package:agritechv2/models/users/Users.dart';
import 'package:agritechv2/repository/auth_repository.dart';

import 'package:agritechv2/repository/message_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:agritechv2/utils/Constants.dart';

import 'package:agritechv2/views/custom%20widgets/user__pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../models/messages.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({super.key});

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        backgroundColor: ColorStyle.brandRed,
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => MessengerBloc(
            messagesRepository: context.read<MessagesRepository>(),
            myID: context.read<AuthRepository>().currentUser?.uid ?? ''),
        child: SingleChildScrollView(
          child: Column(
            children: [
              UserPages(
                onUserClicked: (Users users) => {
                  context.push('/conversation', extra: users),
                },
              ),
              const MessagesList()
            ],
          ),
        ),
      ),
    );
  }
}

class MessagesList extends StatelessWidget {
  const MessagesList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Messenger>>(
      stream: context
          .read<MessagesRepository>()
          .getMyMessages(context.read<AuthRepository>().currentUser?.uid ?? ''),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Messenger> messages = snapshot.data ?? [];
          print("MEssages ${messages.length}");
          List<Messenger> group = removeDuplicateMessages(messages);
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: group.length,
            itemBuilder: (context, index) {
              return ChatContainer(messenger: group[index]);
            },
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  List<Messenger> removeDuplicateMessages(List<Messenger> messages) {
    final Set<String> uniqueIds = <String>{};
    List<Messenger> uniqueMessages = [];

    for (Messenger message in messages) {
      if (uniqueIds.add(message.id)) {
        uniqueMessages.add(message);
      }
    }

    return uniqueMessages;
  }
}

class ChatContainer extends StatefulWidget {
  final Messenger messenger;
  const ChatContainer({super.key, required this.messenger});

  @override
  State<ChatContainer> createState() => _ChatContainerState();
}

class _ChatContainerState extends State<ChatContainer> {
  // Users? _user = widget.messenger.role == Role.CUSTOMER
  //     ? findUserById(users, group[index].receiverID)
  //     : findUserById(users, group[index].senderID);
  Users? _users = null;

  @override
  void initState() {
    String uid = widget.messenger.role == Role.CUSTOMER
        ? widget.messenger.receiverID
        : widget.messenger.senderID;
    getMyInfo(uid);
    super.initState();
  }

  void getMyInfo(String uid) async {
    try {
      Users customer =
          await context.read<MessagesRepository>().getUserInfo(uid);
      setState(() {
        _users = customer;
      });
    } catch (e) {
      print('Error fetching customer data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        if (_users != null) {
          context.push('/conversation', extra: _users);
        } else {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("No user found!")));
        }
      },
      leading: _users != null && _users!.profile.isNotEmpty
          ? CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                _users!.profile,
              ),
            )
          : const CircleAvatar(
              radius: 40, // Adjust the radius as needed
              backgroundImage:
                  AssetImage('lib/assets/images/profile_placeholder.jpg'),
            ),
      title: Text(_users?.name ?? "No name"),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.messenger.message,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
          Align(
            alignment: Alignment.topRight,
            child: Text(
              formatTimeDifference(widget.messenger.createdAt),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
