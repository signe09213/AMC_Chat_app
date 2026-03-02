
import 'package:flutter/material.dart';
import 'models/chat_message.dart';
import 'services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add the initial system message
    _messages.add(ChatMessage(role: 'system', text: GeminiService.systemPrompt, timestamp: DateTime.now()));
  }


  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final userMessage = _controller.text;
    setState(() {
      _messages.add(ChatMessage(role: 'user', text: userMessage, timestamp: DateTime.now()));
      _isLoading = true;
    });

    _controller.clear();

    final response = await GeminiService.sendMultiTurnMessage(_messages, userMessage);

    setState(() {
      _messages.add(ChatMessage(role: 'model', text: response, timestamp: DateTime.now()));
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antogram Creative Assistant'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
              child: Text(
                'Antogram Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to the main screen
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () {
                // Handle about tap
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message.role == 'system') {
                  return const SizedBox.shrink(); // Don't display system messages
                }
                return ListTile(
                  title: Text(message.text),
                  leading: Icon(message.role == 'user' ? Icons.person : Icons.assistant),
                );
              },
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask for creative ideas...',
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
