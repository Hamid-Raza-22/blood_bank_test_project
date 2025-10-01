import 'package:flutter/material.dart';
import '../constant/size_helper.dart';

class ChatDetailScreen extends StatefulWidget {
  final String name;
  final String image;

  const ChatDetailScreen({super.key, required this.name, required this.image});

  @override
  State<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends State<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, String>> messages = [
    {"sender": "other", "message": "Hello! Are you available for donation?"},
    {"sender": "me", "message": "Yes, I can donate tomorrow."},
    {"sender": "other", "message": "Great! See you at the hospital."},
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    setState(() {
      messages.add({"sender": "me", "message": _messageController.text.trim()});
      _messageController.clear();
    });
    // Auto-scroll to bottom after sending
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final Color primaryRed = const Color(0xFF8B0000);

    Widget chatBubble(Map<String, String> msg) {
      bool isMe = msg["sender"] == "me";
      return Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockHeight * 1.5,
              horizontal: SizeConfig.blockWidth * 4),
          margin: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 0.5),
          constraints: BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.7),
          decoration: BoxDecoration(
            color: isMe ? primaryRed : Colors.grey[300],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(isMe ? 12 : 0),
              bottomRight: Radius.circular(isMe ? 0 : 12),
            ),
          ),
          child: Text(
            msg["message"]!,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black87,
              fontSize: SizeConfig.blockWidth * 4,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: SizeConfig.blockWidth * 5,
              backgroundImage: AssetImage(widget.image),
            ),
            SizedBox(width: SizeConfig.blockWidth * 3),
            Text(widget.name),
          ],
        ),
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Chat list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(SizeConfig.blockWidth * 3),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return chatBubble(messages[index]);
              },
            ),
          ),
          // Message input field
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.blockWidth * 3,
                  vertical: SizeConfig.blockHeight * 1),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.blockWidth * 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          hintStyle:
                          TextStyle(fontSize: SizeConfig.blockWidth * 4),
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockWidth * 2),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: CircleAvatar(
                      backgroundColor: primaryRed,
                      radius: SizeConfig.blockWidth * 6,
                      child: Icon(
                        Icons.send,
                        color: Colors.white,
                        size: SizeConfig.blockWidth * 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
