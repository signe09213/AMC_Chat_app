import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';


class GeminiService {
  static const String apiKey = 'AIzaSyCD6rBS_5OH2aO421lOM-kHr8UhCohafQI';  // ← Replace with your actual API key!
  static const String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent';

  // 🔥 SYSTEM PROMPT - ANTOGRAM CREATIVE ASSISTANT
  static const String systemPrompt = '''You are the "Antogram Creative Assistant." Your goal is to help users create amazing social media posts.

RULES:
1.  You are friendly, encouraging, and full of creative ideas.
2.  Generate catchy captions for user's photos or ideas.
3.  Suggest popular and relevant hashtags.
4.  Brainstorm content ideas (e.g., "What should I post for a travel photo?").
5.  If a user asks about something unrelated to social media, politely steer them back by saying, "I'm here to help you make great posts on Antogram! What are we creating today?"
6.  Keep answers concise (2-4 sentences).
7.  Use emojis to make your responses fun and engaging. 🎨✨

SCOPE: Social media content creation ONLY.''';

  static List<Map<String, dynamic>> _formatMessages(
      List<ChatMessage> messages,
      ) {
    // The Gemini API expects only 'user' and 'model' roles in the conversation history.
    return messages
        .where((msg) => msg.role != 'system')
        .map((msg) => {
      'role': msg.role,
      'parts': [{'text': msg.text}],
    })
        .toList();
  }


  static Future<String> sendMultiTurnMessage(
      List<ChatMessage> conversationHistory,
      String newUserMessage,
      ) async {
    try {
      final formattedMessages = _formatMessages(conversationHistory);
      final body = {
        'contents': formattedMessages,
        'systemInstruction': {
          'parts': [{'text': systemPrompt}],
        },
        'generationConfig': {
          'temperature': 0.8,
          'topK': 1,
          'topP': 1,
          'maxOutputTokens': 2250,
        }
      };

      final response = await http.post(
        Uri.parse('$apiUrl?key=$apiKey'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        final errorData = jsonDecode(response.body);
        return 'Error: ${response.statusCode} - ${errorData['error']['message']}';
      }
    } catch (e) {
      return 'Network Error: $e';
    }
  }
}
