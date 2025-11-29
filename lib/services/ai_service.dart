import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class AIService {
  // API Keys - Replace with your actual keys
  static const String geminiKey = 'AIzaSyCT_YhKvW9b5XemcrXy20E__Zlyi5PEO44';
  static const String openRouterKey = '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';
  
  // Gemini Model
  static GenerativeModel? _geminiModel;
  
  static GenerativeModel get geminiModel {
    _geminiModel ??= GenerativeModel(
      model: 'gemini-pro',
      apiKey: geminiKey,
    );
    return _geminiModel!;
  }

  /// Ask Gemini AI a question
  static Future<String> askGemini(String prompt) async {
    try {
      if (geminiKey == 'YOUR_GEMINI_API_KEY_HERE' || geminiKey.isEmpty) {
        return '⚠️ Gemini API key not configured. Please add your API key in lib/services/ai_service.dart';
      }

      final content = [Content.text(prompt)];
      final response = await geminiModel.generateContent(content);
      
      if (response.text != null && response.text!.isNotEmpty) {
        return response.text!;
      } else {
        return 'Sorry, I couldn\'t generate a response. Please try again.';
      }
    } catch (e) {
      return 'Gemini Error: ${e.toString()}';
    }
  }

  /// Ask Llama AI via OpenRouter
  static Future<String> askLlama(String prompt) async {
    try {
      if (openRouterKey == 'YOUR_OPENROUTER_API_KEY_HERE' || openRouterKey.isEmpty) {
        return '⚠️ OpenRouter API key not configured. Please add your API key in lib/services/ai_service.dart';
      }

      final url = Uri.parse('https://openrouter.ai/api/v1/chat/completions');
      
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $openRouterKey',
          'HTTP-Referer': 'https://fluxflow.app',
          'X-Title': 'FluxFlow Student OS',
        },
        body: jsonEncode({
          'model': 'meta-llama/llama-3-8b-instruct:free',
          'messages': [
            {
              'role': 'user',
              'content': prompt,
            }
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['choices'][0]['message']['content'];
        return message ?? 'No response from Llama.';
      } else {
        return 'Llama Error ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      return 'Llama Error: ${e.toString()}';
    }
  }

  /// Get AI model info
  static String getModelInfo(bool isGemini) {
    if (isGemini) {
      return 'Gemini Pro by Google - Fast, accurate, and great for general questions';
    } else {
      return 'Llama 3 by Meta - Open-source, powerful, and free via OpenRouter';
    }
  }
}
