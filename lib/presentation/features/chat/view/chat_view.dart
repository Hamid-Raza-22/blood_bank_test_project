import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/message_entity.dart';
import '../viewmodel/chat_viewmodel.dart';

/// Chat View - Pure UI, no business logic
/// All logic is handled by ChatViewModel
class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late final ChatViewModel controller;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ChatViewModel>();
    // Initialize chat screen after build phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = Get.arguments as Map<String, dynamic>?;
      controller.initChatScreen(args);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(child: _buildMessagesList()),
          _buildMessageInput(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () {
          controller.closeChatRoom();
          Get.back();
        },
      ),
      title: Obx(() => Row(
            children: [
              _buildUserAvatar(),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.otherUserName,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Online',
                    style:
                        TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ],
          )),
      actions: [
        IconButton(
          icon: const Icon(Icons.call),
          onPressed: () => controller.showComingSoon('Voice call'),
        ),
      ],
    );
  }

  Widget _buildUserAvatar() {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white,
      backgroundImage: controller.otherUserPhoto.isNotEmpty
          ? NetworkImage(controller.otherUserPhoto)
          : null,
      child: controller.otherUserPhoto.isEmpty
          ? const Icon(Icons.person, color: Colors.grey, size: 20)
          : null,
    );
  }

  Widget _buildMessagesList() {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error != null && controller.messages.isEmpty) {
        return Center(child: Text(controller.error!));
      }

      if (controller.messages.isEmpty) {
        return const Center(
          child: Text(
            'No messages yet.\nStart the conversation!',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        );
      }

      return ListView.builder(
        controller: controller.scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: controller.messages.length,
        itemBuilder: (context, index) {
          final message = controller.messages[index];
          final isMe = controller.isMessageFromMe(message);
          final isSystem = message.type == 'system';

          if (isSystem) {
            return _buildSystemMessage(message.message);
          }

          return _buildMessageBubble(context, message, isMe);
        },
      );
    });
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: controller.messageController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message...',
                    border: InputBorder.none,
                  ),
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_) => controller.sendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _buildSendButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildSendButton() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: controller.isSendingMessage
                ? AppColors.primary.withOpacity(0.5)
                : AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            onPressed:
                controller.isSendingMessage ? null : () => controller.sendMessage(),
            icon: controller.isSendingMessage
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.send, color: Colors.white),
          ),
        ));
  }

  Widget _buildSystemMessage(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        message,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontStyle: FontStyle.italic,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildMessageBubble(
    BuildContext context,
    MessageEntity message,
    bool isMe,
  ) {
    final time = controller.formatMessageTime(message.createdAt);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: isMe ? Colors.white70 : Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
