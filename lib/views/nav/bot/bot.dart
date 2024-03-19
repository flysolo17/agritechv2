import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatBotPage extends StatefulWidget {
  const ChatBotPage({super.key});

  @override
  State<ChatBotPage> createState() => _ChatBotPageState();
}

class _ChatBotPageState extends State<ChatBotPage> {
  final String key = dotenv.env['API_KEY'] ?? '';
  final ChatUser _user = ChatUser(
    id: '1',
    firstName: 'Charles',
    lastName: 'Leclerc',
  );

  final ChatUser _gpt = ChatUser(
    id: '2',
    firstName: 'Agri',
    lastName: 'Bot',
  );
  final List<ChatMessage> _messages = <ChatMessage>[];
  late OpenAI _openAI;
  @override
  void initState() {
    _openAI = OpenAI.instance.build(
        token: key,
        baseOption: HttpSetup(
          receiveTimeout: const Duration(minutes: 1),
        ),
        enableLog: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DashChat(
        currentUser: _user,
        onSend: (ChatMessage e) {
          getChatReponse(e);
        },
        messages: _messages);
  }

  Future<void> getChatReponse(ChatMessage m) async {
    setState(() {
      _messages.insert(0, m);
    });

    List<Messages> history = _messages.map((e) {
      return m.user == _user
          ? Messages(role: Role.user, content: e.text)
          : Messages(role: Role.assistant, content: e.text);
    }).toList();

    final request = ChatCompleteText(
      model: GptTurbo0301ChatModel(),
      messages: history.reversed.toList(),
      maxToken: 200,
    );
    final response = await _openAI
        .onChatCompletion(request: request)
        .catchError((err) => print(err));

    setState(() {
      if (response != null) {
        for (var element in response.choices) {
          _messages.insert(
            0,
            ChatMessage(
                user: _gpt,
                createdAt: DateTime.now(),
                text: element.message?.content ?? "Sorry I didn't get that!"),
          );
        }
      } else {
        _messages.insert(
          0,
          ChatMessage(
              user: _gpt,
              createdAt: DateTime.now(),
              text: "Sorry I didn't get that!"),
        );
      }
      final test = history.map((e) => e.content).toList();
      print(test.toString());
    });
  }
}
