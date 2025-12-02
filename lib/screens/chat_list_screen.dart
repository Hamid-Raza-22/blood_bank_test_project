import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';
import '../domain/entities/chat_room_entity.dart';
import '../presentation/features/chat/viewmodel/chat_viewmodel.dart';

/// Chat List Screen - Uses ChatViewModel for state management
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    
    // Get or find ChatViewModel
    final ChatViewModel viewModel = Get.find<ChatViewModel>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Chats"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: viewModel.currentUserId.isEmpty
          ? const Center(child: Text('Please log in to view chats'))
          : Padding(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 3),
              child: Column(
                children: [
                  _buildSearchField(viewModel),
                  SizedBox(height: SizeConfig.blockHeight * 2),
                  Expanded(child: _buildChatList(viewModel)),
                ],
              ),
            ),
    );
  }

  Widget _buildSearchField(ChatViewModel viewModel) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockWidth * 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: viewModel.searchController,
        onChanged: viewModel.updateSearchQuery,
        decoration: InputDecoration(
          hintText: "Search chats...",
          hintStyle: TextStyle(fontSize: SizeConfig.blockWidth * 3.8),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Colors.grey[600],
            size: SizeConfig.blockWidth * 6,
          ),
          suffixIcon: Obx(() => viewModel.searchQuery.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, size: SizeConfig.blockWidth * 5),
                  onPressed: viewModel.clearSearch,
                )
              : const SizedBox.shrink()),
        ),
      ),
    );
  }

  Widget _buildChatList(ChatViewModel viewModel) {
    return Obx(() {
      if (viewModel.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (viewModel.error != null && viewModel.filteredChatRooms.isEmpty) {
        return Center(child: Text(viewModel.error!));
      }

      if (viewModel.filteredChatRooms.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey[300]),
              const SizedBox(height: 16),
              Text(
                viewModel.searchQuery.isNotEmpty
                    ? "No chats found"
                    : "No chats yet",
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                viewModel.searchQuery.isNotEmpty
                    ? "Try a different search term"
                    : "Accept a blood request to start chatting",
                style: TextStyle(fontSize: 14, color: Colors.grey[400]),
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        itemCount: viewModel.filteredChatRooms.length,
        itemBuilder: (context, index) {
          final chatRoom = viewModel.filteredChatRooms[index];
          return _buildChatItem(context, chatRoom, viewModel);
        },
      );
    });
  }

  Widget _buildChatItem(
    BuildContext context,
    ChatRoomEntity chatRoom,
    ChatViewModel viewModel,
  ) {
    final otherUserName = viewModel.getOtherUserNameForRoom(chatRoom);
    final otherUserPhoto = viewModel.getOtherUserPhotoForRoom(chatRoom);
    final lastMessage = chatRoom.lastMessage ?? 'No messages';
    final lastMessageTime = chatRoom.lastMessageTime;

    return GestureDetector(
      onTap: () => viewModel.navigateToChat(chatRoom),
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: SizeConfig.blockHeight * 1.5,
            horizontal: SizeConfig.blockWidth * 3),
        margin: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 0.5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: SizeConfig.blockWidth * 6,
              backgroundColor: Colors.grey[200],
              backgroundImage:
                  otherUserPhoto.isNotEmpty ? NetworkImage(otherUserPhoto) : null,
              child: otherUserPhoto.isEmpty
                  ? const Icon(Icons.person, color: Colors.grey)
                  : null,
            ),
            SizedBox(width: SizeConfig.blockWidth * 3),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    otherUserName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.blockWidth * 4,
                    ),
                  ),
                  SizedBox(height: SizeConfig.blockHeight * 0.5),
                  Text(
                    lastMessage,
                    style: TextStyle(
                      fontSize: SizeConfig.blockWidth * 3.5,
                      color: Colors.grey[600],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  viewModel.formatTime(lastMessageTime),
                  style: TextStyle(
                    fontSize: SizeConfig.blockWidth * 3,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


