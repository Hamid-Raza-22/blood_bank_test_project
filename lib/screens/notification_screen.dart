import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../bottom_navigation/bottom_navigation_bar.dart';
import '../constant/size_helper.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final Color primaryRed = const Color(0xFF8B0000);
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("Notifications"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: primaryRed,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
            onPressed: () => _markAllAsRead(currentUserId),
            child: const Text('Mark all read', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: currentUserId == null
          ? const Center(child: Text('Please login to see notifications'))
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('notifications')
                  .where('userId', isEqualTo: currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Error loading notifications'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allNotifications = snapshot.data?.docs ?? [];
                
                // Sort client-side by createdAt descending
                allNotifications.sort((a, b) {
                  final aTime = (a.data() as Map)['createdAt'] as Timestamp?;
                  final bTime = (b.data() as Map)['createdAt'] as Timestamp?;
                  if (aTime == null) return 1;
                  if (bTime == null) return -1;
                  return bTime.compareTo(aTime);
                });

                if (allNotifications.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.notifications_off_outlined,
                            size: 80, color: Colors.grey[300]),
                        const SizedBox(height: 16),
                        Text(
                          'No notifications yet',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // Group notifications by date
                final today = DateTime.now();
                final yesterday = today.subtract(const Duration(days: 1));

                final todayNotifs = <QueryDocumentSnapshot>[];
                final yesterdayNotifs = <QueryDocumentSnapshot>[];
                final earlierNotifs = <QueryDocumentSnapshot>[];

                for (var doc in allNotifications) {
                  final data = doc.data() as Map<String, dynamic>;
                  final timestamp = data['createdAt'] as Timestamp?;
                  if (timestamp == null) {
                    earlierNotifs.add(doc);
                    continue;
                  }
                  
                  final date = timestamp.toDate();
                  if (_isSameDay(date, today)) {
                    todayNotifs.add(doc);
                  } else if (_isSameDay(date, yesterday)) {
                    yesterdayNotifs.add(doc);
                  } else {
                    earlierNotifs.add(doc);
                  }
                }

                return SingleChildScrollView(
                  padding: EdgeInsets.all(SizeConfig.blockWidth * 3),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (todayNotifs.isNotEmpty) ...[
                        _buildNotificationSection('Today', todayNotifs, primaryRed),
                        SizedBox(height: SizeConfig.blockHeight * 2),
                      ],
                      if (yesterdayNotifs.isNotEmpty) ...[
                        _buildNotificationSection('Yesterday', yesterdayNotifs, primaryRed),
                        SizedBox(height: SizeConfig.blockHeight * 2),
                      ],
                      if (earlierNotifs.isNotEmpty)
                        _buildNotificationSection('Earlier', earlierNotifs, primaryRed),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  Widget _buildNotificationSection(
      String title, List<QueryDocumentSnapshot> notifications, Color primaryRed) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Container(
          width: double.infinity,
          color: primaryRed,
          padding: EdgeInsets.symmetric(
              vertical: SizeConfig.blockHeight * 1,
              horizontal: SizeConfig.blockWidth * 4),
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white,
                fontSize: SizeConfig.blockWidth * 4.5,
                fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 4),
        // Notifications list
        ...notifications.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final isRead = data['read'] ?? false;
          final type = data['type'] ?? '';
          final timestamp = data['createdAt'] as Timestamp?;
          final time = timestamp != null
              ? DateFormat('h:mm a').format(timestamp.toDate())
              : '';

          return GestureDetector(
            onTap: () => _onNotificationTap(doc.id, data),
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: SizeConfig.blockHeight * 1.5,
                  horizontal: SizeConfig.blockWidth * 3),
              margin: EdgeInsets.symmetric(vertical: SizeConfig.blockHeight * 0.5),
              decoration: BoxDecoration(
                color: isRead ? Colors.white : Colors.red.shade50,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Left icon based on type
                  CircleAvatar(
                    radius: SizeConfig.blockWidth * 6,
                    backgroundColor: _getIconColor(type),
                    child: Icon(
                      _getIconForType(type),
                      color: Colors.white,
                      size: SizeConfig.blockWidth * 6,
                    ),
                  ),
                  SizedBox(width: SizeConfig.blockWidth * 3),
                  // Title & body
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['title'] ?? 'Notification',
                          style: TextStyle(
                            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                            fontSize: SizeConfig.blockWidth * 4,
                          ),
                        ),
                        SizedBox(height: SizeConfig.blockHeight * 0.5),
                        Text(
                          data['body'] ?? '',
                          style: TextStyle(
                            fontSize: SizeConfig.blockWidth * 3.8,
                            color: Colors.grey[700],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Time
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        time,
                        style: TextStyle(
                          fontSize: SizeConfig.blockWidth * 3.5,
                          color: Colors.grey[600],
                        ),
                      ),
                      if (!isRead)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'new_need':
        return Icons.bloodtype;
      case 'need_accepted':
        return Icons.check_circle;
      case 'chat_message':
        return Icons.chat_bubble;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'new_need':
        return Colors.red;
      case 'need_accepted':
        return Colors.green;
      case 'chat_message':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _onNotificationTap(String notificationId, Map<String, dynamic> data) async {
    // Mark as read
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .update({'read': true});

    // Navigate based on type
    final type = data['type'];
    switch (type) {
      case 'new_need':
        Get.toNamed('/publicNeed');
        break;
      case 'need_accepted':
        final notifData = data['data'] as Map<String, dynamic>?;
        final chatRoomId = notifData?['chatRoomId'];
        if (chatRoomId != null) {
          Get.toNamed('/chat', arguments: {
            'chatRoomId': chatRoomId,
            'otherUserId': notifData?['senderId'] ?? '',
            'otherUserName': notifData?['senderName'] ?? 'User',
            'otherUserPhoto': notifData?['senderPhoto'] ?? '',
          });
        } else {
          Get.toNamed('/chatList');
        }
        break;
      case 'chat_message':
        final notifData = data['data'] as Map<String, dynamic>?;
        final chatRoomId = notifData?['chatRoomId'];
        if (chatRoomId != null) {
          Get.toNamed('/chat', arguments: {
            'chatRoomId': chatRoomId,
            'otherUserId': notifData?['senderId'] ?? '',
            'otherUserName': notifData?['senderName'] ?? 'User',
            'otherUserPhoto': notifData?['senderPhoto'] ?? '',
          });
        } else {
          Get.toNamed('/chatList');
        }
        break;
      default:
        break;
    }
  }

  void _markAllAsRead(String? userId) async {
    if (userId == null) return;
    
    final batch = FirebaseFirestore.instance.batch();
    final notifications = await FirebaseFirestore.instance
        .collection('notifications')
        .where('userId', isEqualTo: userId)
        .where('read', isEqualTo: false)
        .get();

    for (var doc in notifications.docs) {
      batch.update(doc.reference, {'read': true});
    }
    await batch.commit();
    
    Get.snackbar('Done', 'All notifications marked as read',
        backgroundColor: Colors.green, colorText: Colors.white);
  }
}
