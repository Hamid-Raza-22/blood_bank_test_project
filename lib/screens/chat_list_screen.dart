import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/colors.dart';
import '../constant/size_helper.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Chats"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: currentUserId == null
          ? const Center(child: Text('Please log in to view chats'))
          : Padding(
              padding: EdgeInsets.all(SizeConfig.blockWidth * 3),
              child: Column(
                children: [
                  _buildSearchField(),
                  SizedBox(height: SizeConfig.blockHeight * 2),
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chat_rooms')
                          .where('participants', arrayContains: currentUserId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          debugPrint('ChatList Error: ${snapshot.error}');
                          return const Center(child: Text('Error loading chats'));
                        }
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        // Sort client-side to avoid index requirement
                        final chatRooms = snapshot.data?.docs ?? [];
                        chatRooms.sort((a, b) {
                          final aTime = (a.data() as Map)['lastMessageTime'] as Timestamp?;
                          final bTime = (b.data() as Map)['lastMessageTime'] as Timestamp?;
                          if (aTime == null) return 1;
                          if (bTime == null) return -1;
                          return bTime.compareTo(aTime);
                        });

                        if (chatRooms.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.chat_bubble_outline,
                                    size: 80, color: Colors.grey[300]),
                                const SizedBox(height: 16),
                                Text(
                                  "No chats yet",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey[600]),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "Accept a blood request to start chatting",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey[400]),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: chatRooms.length,
                          itemBuilder: (context, index) {
                            final data =
                                chatRooms[index].data() as Map<String, dynamic>;
                            final chatRoomId = chatRooms[index].id;
                            return _buildChatItem(
                                context, chatRoomId, data, currentUserId);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.blockWidth * 4),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search chats...",
          hintStyle: TextStyle(fontSize: SizeConfig.blockWidth * 3.8),
          border: InputBorder.none,
          icon: Icon(
            Icons.search,
            color: Colors.grey[600],
            size: SizeConfig.blockWidth * 6,
          ),
        ),
      ),
    );
  }

  Widget _buildChatItem(BuildContext context, String chatRoomId,
      Map<String, dynamic> data, String currentUserId) {
    // Get the other participant's info
    final participants = List<String>.from(data['participants'] ?? []);
    final otherUserId =
        participants.firstWhere((id) => id != currentUserId, orElse: () => '');
    
    final participantNames =
        Map<String, dynamic>.from(data['participantNames'] ?? {});
    final participantPhotos =
        Map<String, dynamic>.from(data['participantPhotos'] ?? {});
    
    final otherUserName = participantNames[otherUserId] ?? 'User';
    final otherUserPhoto = participantPhotos[otherUserId] ?? '';
    final lastMessage = data['lastMessage'] ?? 'No messages';
    final lastMessageTime = data['lastMessageTime'] as Timestamp?;
    final bloodType = data['bloodType'] ?? '';

    return GestureDetector(
      onTap: () {
        Get.toNamed('/chat', arguments: {
          'chatRoomId': chatRoomId,
          'otherUserId': otherUserId,
          'otherUserName': otherUserName,
          'otherUserPhoto': otherUserPhoto,
        });
      },
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
            Stack(
              children: [
                CircleAvatar(
                  radius: SizeConfig.blockWidth * 6,
                  backgroundColor: Colors.grey[200],
                  backgroundImage: otherUserPhoto.isNotEmpty
                      ? NetworkImage(otherUserPhoto)
                      : null,
                  child: otherUserPhoto.isEmpty
                      ? const Icon(Icons.person, color: Colors.grey)
                      : null,
                ),
                if (bloodType.isNotEmpty)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        bloodType,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
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
                  _formatTime(lastMessageTime),
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

  String _formatTime(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final now = DateTime.now();
    final date = timestamp.toDate();
    final diff = now.difference(date);

    if (diff.inDays > 0) {
      return '${diff.inDays}d';
    } else if (diff.inHours > 0) {
      return '${diff.inHours}h';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes}m';
    } else {
      return 'now';
    }
  }
}


