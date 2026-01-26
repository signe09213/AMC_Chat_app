import 'package:flutter/material.dart';
import 'screens/chat_screen.dart';

void main() => runApp(ChatApp());

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Expert Assistant',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey[100], 
      ),
      home: ChatScreen(),
    );
  }
}
