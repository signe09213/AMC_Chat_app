import 'package:flutter/material.dart';

class InputBar extends StatefulWidget {
  final Function(String) onSendMessage;

  const InputBar({super.key, required this.onSendMessage});

  @override
  State<InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      widget.onSendMessage(_controller.text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Type a message...',
              ),
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }
}
