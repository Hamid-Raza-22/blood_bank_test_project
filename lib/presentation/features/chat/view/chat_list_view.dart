import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/chat_room_entity.dart';
import '../viewmodel/chat_viewmodel.dart';

/// Chat List View - Pure UI, no business logic
/// Shows list of chat conversations
class ChatListView extends GetView<ChatViewModel> {
  const ChatListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildChatList()),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      title: const Text('Messages'),
      elevation: 0,
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: TextField(
        controller: controller.searchController,
        decoration: InputDecoration(
          hintText: 'Search conversations...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(() => controller.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: controller.clearSearch,
                )
              : const SizedBox.shrink()),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: controller.updateSearchQuery,
      ),
    );
  }

  Widget _buildChatList() {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.error != null && controller.filteredChatRooms.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.grey),
              const SizedBox(height: 16),
              Text(controller.error!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: controller.loadChatRooms,
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      }

      if (controller.filteredChatRooms.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline,
                  size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                controller.searchQuery.isNotEmpty
                    ? 'No conversations found'
                    : 'No conversations yet',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              if (controller.searchQuery.isEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Start chatting with donors!',
                  style: TextStyle(color: Colors.grey[400]),
                ),
              ],
            ],
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: () async => controller.loadChatRooms(),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: controller.filteredChatRooms.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final chatRoom = controller.filteredChatRooms[index];
            return _buildChatItem(chatRoom);
          },
        ),
      );
    });
  }

  Widget _buildChatItem(ChatRoomEntity chatRoom) {
    final name = controller.getOtherUserNameForRoom(chatRoom);
    final photo = controller.getOtherUserPhotoForRoom(chatRoom);
    final lastMessage = chatRoom.lastMessage ?? 'No messages';
    final time = controller.formatTime(chatRoom.lastMessageTime);
    final unreadCount = chatRoom.unreadCount?[controller.currentUserId] ?? 0;

    return InkWell(
      onTap: () => controller.navigateToChat(chatRoom),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.white,
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: photo.isNotEmpty ? NetworkImage(photo) : null,
              child: photo.isEmpty
                  ? Text(
                      name.isNotEmpty ? name[0].toUpperCase() : 'U',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: unreadCount > 0
                                ? FontWeight.bold
                                : FontWeight.w600,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        time,
                        style: TextStyle(
                          color: unreadCount > 0
                              ? AppColors.primary
                              : Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          style: TextStyle(
                            color: unreadCount > 0
                                ? Colors.black87
                                : Colors.grey[600],
                            fontWeight: unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            unreadCount > 99 ? '99+' : unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
