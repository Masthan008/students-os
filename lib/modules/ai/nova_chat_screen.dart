import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../services/ai_service.dart';

class NovaChatScreen extends StatefulWidget {
  const NovaChatScreen({super.key});

  @override
  State<NovaChatScreen> createState() => _NovaChatScreenState();
}

class _NovaChatScreenState extends State<NovaChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isGemini = true; // true = Gemini, false = Llama
  bool _isThinking = false;

  @override
  void initState() {
    super.initState();
    // Welcome message
    _messages.add(ChatMessage(
      text: 'Hello! I\'m Nova AI, your intelligent study assistant. Ask me anything about your studies, homework, or any topic you\'re curious about!',
      isUser: false,
      timestamp: DateTime.now(),
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isThinking) return;

    // Add user message
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
      _isThinking = true;
    });

    _controller.clear();
    _scrollToBottom();

    // Get AI response
    try {
      final response = _isGemini
          ? await AIService.askGemini(text)
          : await AIService.askLlama(text);

      setState(() {
        _messages.add(ChatMessage(
          text: response,
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isThinking = false;
      });

      _scrollToBottom();
    } catch (e) {
      setState(() {
        _messages.add(ChatMessage(
          text: 'Sorry, I encountered an error: ${e.toString()}',
          isUser: false,
          timestamp: DateTime.now(),
        ));
        _isThinking = false;
      });
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _clearChat() {
    setState(() {
      _messages.clear();
      _messages.add(ChatMessage(
        text: 'Chat cleared! How can I help you?',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            const Icon(Icons.psychology, color: Colors.purple, size: 28),
            const SizedBox(width: 12),
            Text(
              'Nova AI',
              style: GoogleFonts.orbitron(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.purple),
        actions: [
          // Model Switcher
          PopupMenuButton<bool>(
            icon: Icon(
              _isGemini ? Icons.auto_awesome : Icons.rocket_launch,
              color: Colors.purple,
            ),
            tooltip: 'Switch AI Model',
            onSelected: (value) {
              setState(() {
                _isGemini = value;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Switched to ${value ? "Gemini" : "Llama"} AI',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Colors.purple,
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: true,
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome, color: Colors.blue),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Gemini Pro'),
                        Text(
                          'By Google',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuItem(
                value: false,
                child: Row(
                  children: [
                    const Icon(Icons.rocket_launch, color: Colors.orange),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Llama 3'),
                        Text(
                          'By Meta',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          // Clear Chat
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _clearChat,
            tooltip: 'Clear Chat',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade900, Colors.black],
          ),
        ),
        child: Column(
          children: [
            // Model Info Banner
            Container(
              padding: const EdgeInsets.all(12),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.purple.withOpacity(0.5)),
              ),
              child: Row(
                children: [
                  Icon(
                    _isGemini ? Icons.auto_awesome : Icons.rocket_launch,
                    color: Colors.purple,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      AIService.getModelInfo(_isGemini),
                      style: GoogleFonts.montserrat(
                        color: Colors.purple.shade200,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Messages List
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return _buildMessageBubble(message);
                },
              ),
            ),

            // Thinking Indicator
            if (_isThinking)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const SizedBox(width: 16),
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(Colors.purple),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Nova is thinking...',
                      style: GoogleFonts.montserrat(
                        color: Colors.purple,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

            // Input Bar
            Container(
              padding: EdgeInsets.only(
                bottom: 80, // Space for bottom nav
                left: 16,
                right: 16,
                top: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      maxLines: null,
                      decoration: InputDecoration(
                        hintText: 'Ask Nova anything...',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Colors.purple, Colors.purple.shade700],
                        ),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.psychology,
                color: Colors.purple,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser
                    ? Colors.purple.withOpacity(0.3)
                    : Colors.grey.shade900,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(message.isUser ? 18 : 4),
                  bottomRight: Radius.circular(message.isUser ? 4 : 18),
                ),
                border: Border.all(
                  color: message.isUser
                      ? Colors.purple.withOpacity(0.5)
                      : Colors.grey.shade800,
                ),
              ),
              child: MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  code: GoogleFonts.firaCode(
                    backgroundColor: Colors.black,
                    color: Colors.cyanAccent,
                  ),
                  codeblockDecoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 24,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
