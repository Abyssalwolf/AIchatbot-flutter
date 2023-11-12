import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> messages = [];
  static const apiUri = 'https://api.openai.com/v1/chat/completions';
  static const apiKey = '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';

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      "role": "user",
      "content":
          "You are a banking called CodeBot and you are only supposed to talk about banking.$prompt",
    });
    try {
      final res = await http.post(
        Uri.parse(apiUri),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer $apiKey',
          'OpenAI-Organization': ''
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo-16k",
          "messages": messages,
          "temperature": 0.5
        }),
      );

      print(res.body);

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}