import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../services/ai_service.dart';

class FluxAIScreen extends StatefulWidget {
  const FluxAIScreen({super.key});

  @override
  State<FluxAIScreen> createState() => _FluxAIScreenState();
}

class _FluxAIScreenState extends State<FluxAIScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isGemini = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Add welcome message
    _messages.add({
      'role': 'ai',
      'content': '👋 Hello! I\'m Flux AI, your intelligent study assistant powered by ${_isGemini ? "Gemini" : "Llama"}. Ask me anything about your studies, homework, or any topic you\'re curious about!\n\n💡 **Tip:** You can switch between Gemini and Llama models using the toggle above.'
    });
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    final prompt = _controller.text;
    setState(() {
      _messages.add({'role': 'user', 'content': prompt});
      _isLoading = true;
    });

    _controller.clear();

    try {
      String response;
      if (_isGemini) {
        response = await AIService.askGemini(prompt);
      } else {
        response = await AIService.askLlama(prompt);
      }

      setState(() {
        _messages.add({'role': 'ai', 'content': response});
      });
    } catch (e) {
      setState(() {
        _messages.add({'role': 'ai', 'content': 'Error: $e'});
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Flux AI",
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          Switch(
            value: _isGemini,
            activeColor: Colors.cyanAccent,
            onChanged: (val) => setState(() => _isGemini = val),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(
              _isGemini ? "Gemini" : "Llama",
              style: TextStyle(
                color: _isGemini ? Colors.cyan : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['role'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.8,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.cyan.withOpacity(0.2)
                          : Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isUser ? Colors.cyan : Colors.white24,
                      ),
                    ),
                    child: isUser
                        ? Text(
                            msg['content']!,
                            style: const TextStyle(color: Colors.white),
                          )
                        : MarkdownBody(
                            data: msg['content']!,
                            styleSheet: MarkdownStyleSheet.fromTheme(
                              Theme.of(context),
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          if (_isLoading)
            const LinearProgressIndicator(color: Colors.cyanAccent),
          Container(
            padding: const EdgeInsets.all(10),
            color: Colors.grey[900],
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: "Ask Flux AI...",
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.cyanAccent),
                    onPressed: _sendMessage,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
