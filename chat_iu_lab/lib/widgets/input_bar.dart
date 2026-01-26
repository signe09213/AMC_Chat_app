import 'package:flutter/material.dart';

class InputBar extends StatefulWidget {
  final Function(String) onSendMessage;
  final bool enabled;

  const InputBar({
    Key? key,
    required this.onSendMessage,
    this.enabled = true,
  }) : super(key: key);

  @override
  _InputBarState createState() => _InputBarState();
}

class _InputBarState extends State<InputBar> {
  final _textController = TextEditingController();

  void _handleSend() {
    if (_textController.text.isNotEmpty) {
      widget.onSendMessage(_textController.text);
      _textController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Type your message here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              enabled: widget.enabled,
              onSubmitted: widget.enabled ? (_) => _handleSend() : null,
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: widget.enabled ? _handleSend : null,
            style: IconButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
