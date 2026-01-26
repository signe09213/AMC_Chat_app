import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../widgets/message_bubble.dart';
import '../widgets/input_bar.dart';
import '../services/gemini_service.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> messages = [];
  final ScrollController scrollController = ScrollController();
  bool _isLoading = false;

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void addMessage(String text, String role) {
    setState(() {
      messages.add(ChatMessage(
        text: text,
        role: role,
        timestamp: DateTime.now(),
      ));
    });
    scrollToBottom();
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> handleSend(String text) async {
    if (text.isEmpty) return;

    addMessage(text, "user");
    setState(() => _isLoading = true);

    try {
      final aiResponse = await GeminiService.sendMultiTurnMessage(
        messages, 
        text, 
      );
      addMessage(aiResponse, "model");
    } catch (e) {
      addMessage('❌ Error: $e', "model");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Chat - Multi-Turn Week 4'),
      ),
      body: Column(
        children: [
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.chat_bubble_outline, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'Start chatting!',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const Text(
                          'Multi-turn means Gemini remembers context',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(8.0),
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(message: messages[index]);
                    },
                  ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: 12),
                  Text('🤖 Thinking with context...'),
                ],
              ),
            ),
          InputBar(onSendMessage: handleSend, enabled: !_isLoading),
        ],
      ),
    );
  }
}
