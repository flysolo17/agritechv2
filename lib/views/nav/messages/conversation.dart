import 'package:agritechv2/blocs/messenger/messenger_bloc.dart';
import 'package:agritechv2/models/messages.dart';
import 'package:agritechv2/models/users/Customer.dart';
import 'package:agritechv2/repository/auth_repository.dart';
import 'package:agritechv2/repository/customer_repository.dart';
import 'package:agritechv2/repository/message_repository.dart';
import 'package:agritechv2/styles/color_styles.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';

import '../../../models/users/Users.dart';

class ConversationPage extends StatefulWidget {
  final Users users;
  const ConversationPage({super.key, required this.users});

  @override
  State<ConversationPage> createState() => _ConversationPageState();
}

class _ConversationPageState extends State<ConversationPage> {
  late UserRepository userRepo;

  late MessagesRepository messagesRepository;
  final ChatUser _customer = ChatUser(
    id: '',
    firstName: '',
    lastName: '',
  );
  final ChatUser _staff = ChatUser(
    id: '',
    firstName: '',
    lastName: '',
  );

  final List<ChatMessage> _messageList = <ChatMessage>[];
  @override
  void initState() {
    String myID = context.read<AuthRepository>().currentUser?.uid ?? '';
    userRepo = context.read<UserRepository>();
    messagesRepository = context.read<MessagesRepository>();
    getMyInfo(myID);
    setState(() {
      _staff.id = widget.users.id;
      _staff.firstName = widget.users.name;
      _customer.id = myID;
      if (widget.users.profile.isNotEmpty) {
        _staff.profileImage = widget.users.profile;
      }
      initStream(_customer.id);
    });
    super.initState();
  }

  void getMyInfo(String uid) async {
    try {
      Customer customer = await userRepo.getCustomerInfo(uid);
      setState(() {
        _customer.firstName = customer.name;
      });
    } catch (e) {
      print('Error fetching customer data: $e');
    }
  }

  void initStream(
    String customerID,
  ) {
    messagesRepository
        .getConversation(customerID, widget.users.id)
        .listen((event) {
      print(event.length);
      List<ChatMessage> messages = event
          .map((e) => ChatMessage(
              user: e.role == Role.CUSTOMER ? _customer : _staff,
              createdAt: e.createdAt,
              text: e.message))
          .toList();
      _messageList.clear();
      setState(() {
        _messageList.addAll(messages);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: ColorStyle.brandRed,
          title: Text(widget.users.name,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
              maxLines: 1),
        ),
        body: BlocProvider(
          create: (context) => MessengerBloc(
              messagesRepository: context.read<MessagesRepository>(),
              myID: context.read<AuthRepository>().currentUser?.uid ?? ''),
          child: BlocConsumer<MessengerBloc, MessengerState>(
            listener: (context, state) {
              if (state is MessengerStateSuccessState<String>) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.data)));
              }
              if (state is MessengerStateErrorState) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(state.error)));
              }
            },
            builder: (context, state) {
              return DashChat(
                  currentUser: _customer,
                  onSend: (ChatMessage e) {
                    sendMessage(context, _customer.id, _staff.id, e.text);
                  },
                  messages: _messageList);
            },
          ),
        ));
  }

  void sendMessage(BuildContext context, String senderID, String receiverID,
      String message) {
    context.read<MessengerBloc>().add(
          SendMessage(
            Messenger(
              id: '',
              senderID: senderID,
              receiverID: receiverID,
              role: Role.CUSTOMER,
              message: message,
              seen: false,
              createdAt: DateTime.now(),
            ),
          ),
        );
  }
}
