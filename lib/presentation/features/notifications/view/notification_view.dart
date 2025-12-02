import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/notification_entity.dart';
import '../viewmodel/notification_viewmodel.dart';

/// Notification View - Pure UI, no business logic
/// Shows list of notifications grouped by date
class NotificationView extends GetView<NotificationViewModel> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('Notifications'),
        elevation: 0,
        actions: [
          Obx(() => controller.unreadCount > 0
              ? TextButton(
                  onPressed: controller.markAllAsRead,
                  child: const Text(
                    'Mark all read',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : const SizedBox.shrink()),
        ],
      ),
      body: _buildNotificationList(),
    );
  }

  Widget _buildNotificationList() {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.notifications.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'No notifications yet',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            ],
          ),
        );
      }

      return ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Today's notifications
          if (controller.todayNotifications.isNotEmpty) ...[
            _buildSectionHeader('Today'),
            ...controller.todayNotifications.map(_buildNotificationItem),
          ],
          // Yesterday's notifications
          if (controller.yesterdayNotifications.isNotEmpty) ...[
            _buildSectionHeader('Yesterday'),
            ...controller.yesterdayNotifications.map(_buildNotificationItem),
          ],
          // Earlier notifications
          if (controller.earlierNotifications.isNotEmpty) ...[
            _buildSectionHeader('Earlier'),
            ...controller.earlierNotifications.map(_buildNotificationItem),
          ],
        ],
      );
    });
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationEntity notification) {
    final icon = controller.getIconForType(notification.type);
    final color = controller.getColorForType(notification.type);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => controller.deleteNotification(notification.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: notification.isRead ? Colors.white : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
          border: notification.isRead
              ? Border.all(color: Colors.grey.shade200)
              : Border.all(color: Colors.blue.shade100),
        ),
        child: InkWell(
          onTap: () => controller.onNotificationTap(notification),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 12),
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.title,
                        style: TextStyle(
                          fontWeight: notification.isRead
                              ? FontWeight.normal
                              : FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        notification.body,
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatTime(notification.createdAt),
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                // Unread indicator
                if (!notification.isRead)
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }
}
