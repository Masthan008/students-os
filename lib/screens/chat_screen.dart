import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  String _currentUser = 'Student';
  String _currentRole = 'student';
  int _onlineCount = 0;
  Map<String, dynamic>? _replyingTo;
  bool _isSearching = false;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final box = Hive.box('user_prefs');
    _currentUser = box.get('user_name', defaultValue: 'Student');
    _currentRole = box.get('role', defaultValue: 'student');
    _trackPresence();
  }

  void _trackPresence() {
    // Track online presence using Supabase Realtime
    try {
      final channel = Supabase.instance.client.channel('online_users');
      
      channel.onPresenceSync((payload) {
        setState(() {
          _onlineCount = channel.presenceState().length;
        });
      }).subscribe((status, error) async {
        if (status == RealtimeSubscribeStatus.subscribed) {
          await channel.track({'user': _currentUser});
        }
      });
    } catch (e) {
      // Presence tracking failed, continue without it
      print('Presence tracking error: $e');
    }
  }

  Future<void> _deleteMessage(int messageId, String sender) async {
    // Only allow deletion if it's your message OR you're a teacher
    final canDelete = sender == _currentUser || _currentRole == 'teacher';
    
    if (!canDelete) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only delete your own messages')),
      );
      return;
    }

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Delete Message?', style: TextStyle(color: Colors.white)),
        content: const Text(
          'This message will be deleted for everyone.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await Supabase.instance.client
            .from('chat_messages')
            .delete()
            .eq('id', messageId);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Message deleted')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error deleting message: $e')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    try {
      final messageData = <String, dynamic>{
        'sender': _currentUser,
        'message': message,
        'created_at': DateTime.now().toIso8601String(),
      };
      
      if (_replyingTo != null) {
        messageData['reply_to'] = _replyingTo!['id'] as int;
        messageData['reply_message'] = _replyingTo!['message'] as String;
        messageData['reply_sender'] = _replyingTo!['sender'] as String;
      }

      await Supabase.instance.client.from('chat_messages').insert(messageData);

      _messageController.clear();
      setState(() {
        _replyingTo = null;
      });
      
      // Scroll to bottom
      Future.delayed(const Duration(milliseconds: 100), () {
        if (_scrollController.hasClients && mounted) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending message: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _reactToMessage(int messageId, String emoji) async {
    try {
      // Fetch current message to get existing reactions
      final response = await Supabase.instance.client
          .from('chat_messages')
          .select('reactions')
          .eq('id', messageId)
          .single();
      
      Map<String, dynamic> reactions = {};
      if (response['reactions'] != null && response['reactions'] is Map) {
        reactions = Map<String, dynamic>.from(response['reactions']);
      }
      
      // Toggle reaction for current user
      if (reactions.containsKey(emoji)) {
        final users = List<String>.from(reactions[emoji]);
        if (users.contains(_currentUser)) {
          users.remove(_currentUser);
          if (users.isEmpty) {
            reactions.remove(emoji);
          } else {
            reactions[emoji] = users;
          }
        } else {
          users.add(_currentUser);
          reactions[emoji] = users;
        }
      } else {
        reactions[emoji] = [_currentUser];
      }
      
      await Supabase.instance.client.from('chat_messages').update({
        'reactions': reactions,
      }).eq('id', messageId);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding reaction: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _replyToMessage(Map<String, dynamic> message) {
    setState(() {
      _replyingTo = message;
    });
    _focusNode.requestFocus();
  }

  void _showReactionPicker(int messageId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('React to message', style: TextStyle(color: Colors.white)),
        content: Wrap(
          spacing: 12,
          children: ['❤️', '😂', '👍', '👎', '😮', '🎉'].map((emoji) {
            return GestureDetector(
              onTap: () {
                _reactToMessage(messageId, emoji);
                Navigator.pop(context);
              },
              child: Text(emoji, style: const TextStyle(fontSize: 32)),
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark grey background
      resizeToAvoidBottomInset: true, // Critical for keyboard
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hub - Chatroom',
              style: GoogleFonts.orbitron(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            if (_onlineCount > 0)
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$_onlineCount Online',
                    style: GoogleFonts.montserrat(
                      color: Colors.grey.shade400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List - Takes all available space
          Expanded(
            child: Column(
              children: [
                // Search bar
                if (_isSearching)
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.grey.shade900,
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Search messages...',
                        hintStyle: TextStyle(color: Colors.grey.shade600),
                        filled: true,
                        fillColor: Colors.black,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value.toLowerCase();
                        });
                      },
                    ),
                  ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      // Subtle pattern background
                      color: const Color(0xFF121212),
                      image: DecorationImage(
                        image: const NetworkImage(
                          'https://www.transparenttextures.com/patterns/dark-matter.png',
                        ),
                        repeat: ImageRepeat.repeat,
                        opacity: 0.05,
                        onError: (exception, stackTrace) {
                          // Fallback if pattern fails to load
                        },
                      ),
                    ),
                    child: StreamBuilder<List<Map<String, dynamic>>>(
                      stream: Supabase.instance.client
                          .from('chat_messages')
                          .stream(primaryKey: ['id'])
                          .order('created_at', ascending: true),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error, color: Colors.red, size: 48),
                                const SizedBox(height: 16),
                                Text(
                                  'Error loading messages',
                                  style: GoogleFonts.montserrat(color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${snapshot.error}',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          );
                        }

                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.chat_bubble_outline, 
                                  color: Colors.grey, size: 64),
                                const SizedBox(height: 16),
                                Text(
                                  'No messages yet',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Be the first to say hello!',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.grey.shade700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final messages = snapshot.data!;
                        
                        // Filter messages based on search
                        final filteredMessages = _searchQuery.isEmpty
                            ? messages
                            : messages.where((msg) {
                                final message = (msg['message'] ?? '').toString().toLowerCase();
                                final sender = (msg['sender'] ?? '').toString().toLowerCase();
                                return message.contains(_searchQuery) || sender.contains(_searchQuery);
                              }).toList();
                        
                        // Auto-scroll to bottom when new messages arrive
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          if (_scrollController.hasClients && _searchQuery.isEmpty) {
                            _scrollController.jumpTo(
                              _scrollController.position.maxScrollExtent,
                            );
                          }
                        });

                        return ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 20), // Extra bottom padding
                          itemCount: filteredMessages.length,
                          itemBuilder: (context, index) {
                            final msg = filteredMessages[index];
                            final sender = msg['sender'] ?? 'Unknown';
                            final message = msg['message'] ?? '';
                            final isMe = sender == _currentUser;
                            final isTeacher = sender.toLowerCase().contains('teacher') || 
                                             sender.toLowerCase().contains('prof') ||
                                             sender.toLowerCase().contains('sir') ||
                                             sender.toLowerCase().contains('madam');

                            return _buildMessageBubble(
                              messageId: msg['id'],
                              sender: sender,
                              message: message,
                              isMe: isMe,
                              isTeacher: isTeacher,
                              replyTo: msg['reply_message'],
                              replySender: msg['reply_sender'],
                              reactions: msg['reactions'],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Input Bar - Pinned to bottom with extra padding for bottom nav
          Container(
            padding: const EdgeInsets.only(
              bottom: 80, // Fixed padding to clear bottom navigation bar (typically 56-80px)
              left: 10,
              right: 10,
              top: 10,
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Reply preview
                if (_replyingTo != null)
                  Container(
                    padding: const EdgeInsets.all(8),
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.reply, color: Colors.cyanAccent, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Replying to ${_replyingTo!['sender']}',
                                style: GoogleFonts.montserrat(
                                  color: Colors.cyanAccent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                _replyingTo!['message'],
                                style: GoogleFonts.montserrat(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.grey, size: 16),
                          onPressed: () {
                            setState(() {
                              _replyingTo = null;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        focusNode: _focusNode,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type a message...',
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
                        maxLines: null,
                        textInputAction: TextInputAction.send,
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: _sendMessage,
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [Colors.cyanAccent, Colors.blueAccent],
                          ),
                        ),
                        child: const Icon(
                          Icons.send,
                          color: Colors.black,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble({
    required int messageId,
    required String sender,
    required String message,
    required bool isMe,
    required bool isTeacher,
    String? replyTo,
    String? replySender,
    dynamic reactions,
  }) {
    return GestureDetector(
      onLongPress: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.grey.shade900,
          builder: (context) => Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.reply, color: Colors.cyanAccent),
                  title: const Text('Reply', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    _replyToMessage({'id': messageId, 'sender': sender, 'message': message});
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.emoji_emotions, color: Colors.yellow),
                  title: const Text('React', style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Navigator.pop(context);
                    _showReactionPicker(messageId);
                  },
                ),
                if (sender == _currentUser || _currentRole == 'teacher')
                  ListTile(
                    leading: const Icon(Icons.delete, color: Colors.red),
                    title: const Text('Delete', style: TextStyle(color: Colors.white)),
                    onTap: () {
                      Navigator.pop(context);
                      _deleteMessage(messageId, sender);
                    },
                  ),
              ],
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMe) ...[
            // Avatar for others
            CircleAvatar(
              backgroundColor: isTeacher 
                ? Colors.orange.shade700 
                : Colors.grey.shade800,
              radius: 18,
              child: Text(
                sender[0].toUpperCase(),
                style: TextStyle(
                  color: isTeacher ? Colors.white : Colors.cyanAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: isMe 
                ? CrossAxisAlignment.end 
                : CrossAxisAlignment.start,
              children: [
                if (!isMe)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4, left: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          sender,
                          style: GoogleFonts.montserrat(
                            fontSize: 12,
                            color: isTeacher ? Colors.orange : Colors.grey.shade400,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (isTeacher) ...[
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified,
                            size: 14,
                            color: Colors.orange,
                          ),
                        ],
                      ],
                    ),
                  ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    // Me: Gradient Cyan/Blue (Right side)
                    // Teacher: Gold/Orange border (Left side)
                    // Others: Dark Grey (Left side)
                    gradient: isMe
                        ? const LinearGradient(
                            colors: [Color(0xFF00BCD4), Color(0xFF2196F3)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isMe ? null : const Color(0xFF2A2A2A),
                    border: isTeacher && !isMe
                        ? Border.all(
                            color: Colors.orange,
                            width: 2,
                          )
                        : null,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(18),
                      topRight: const Radius.circular(18),
                      bottomLeft: Radius.circular(isMe ? 18 : 4),
                      bottomRight: Radius.circular(isMe ? 4 : 18),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isMe 
                          ? Colors.cyanAccent.withOpacity(0.3)
                          : Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Reply preview
                      if (replyTo != null && replySender != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                replySender,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white.withOpacity(0.7),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                replyTo,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 11,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      Text(
                        message,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                      // Reactions display
                      if (reactions != null && reactions is Map && reactions.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: (reactions as Map<String, dynamic>).entries.map((entry) {
                              final emoji = entry.key;
                              final users = List<String>.from(entry.value);
                              final count = users.length;
                              final hasReacted = users.contains(_currentUser);
                              
                              return GestureDetector(
                                onTap: () => _reactToMessage(messageId, emoji),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: hasReacted 
                                        ? Colors.cyanAccent.withOpacity(0.3)
                                        : Colors.black.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: hasReacted 
                                          ? Colors.cyanAccent
                                          : Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(emoji, style: const TextStyle(fontSize: 14)),
                                      if (count > 1) ...[
                                        const SizedBox(width: 4),
                                        Text(
                                          '$count',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isMe) ...[
            const SizedBox(width: 10),
            // Avatar for me
            CircleAvatar(
              backgroundColor: Colors.cyanAccent,
              radius: 18,
              child: Text(
                sender[0].toUpperCase(),
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ],
      ),
      ),
    );
  }
}
