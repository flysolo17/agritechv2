import 'package:flutter/material.dart';

class MessageContainer extends StatefulWidget {
  final String message;
  Function(String message) onMessageChange;
  MessageContainer(
      {super.key, required this.message, required this.onMessageChange});

  @override
  State<MessageContainer> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageContainer> {
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    _messageController.text = widget.message;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Message",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[400],
          ),
        ),
        Expanded(
          child: TextField(
            onSubmitted: (value) {
              widget.onMessageChange(value);
            },
            controller: _messageController,
            textAlign: TextAlign.end,
            decoration: const InputDecoration(
              hintText: 'Please leave a message',
              hintTextDirection: TextDirection.ltr,
              hintStyle: TextStyle(
                fontWeight: FontWeight.w100,
                color: Colors.red,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }
}
