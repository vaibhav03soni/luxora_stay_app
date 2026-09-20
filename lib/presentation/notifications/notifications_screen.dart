import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/dependency_injection.dart';
import '../../core/services/notification_service.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notificationService = sl<NotificationService>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<List<AppNotification>>(
        stream: notificationService.notifications,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmptyState();
          }

          final notifications = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: notifications.length,
            separatorBuilder: (context, index) => const Divider(height: 24),
            itemBuilder: (context, index) {
              final n = notifications[index];
              return ListTile(
                onTap: () => notificationService.markAsRead(n.id),
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                  backgroundColor: n.isRead ? Colors.grey[100] : AppColors.secondary.withValues(alpha: 0.1),
                  child: Icon(
                    n.isRead ? Icons.notifications_none : Icons.notifications_active,
                    color: n.isRead ? Colors.grey : AppColors.secondary,
                  ),
                ),
                title: Text(
                  n.title,
                  style: TextStyle(
                    fontWeight: n.isRead ? FontWeight.normal : FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Text(n.body, style: TextStyle(color: n.isRead ? Colors.grey : Colors.black87)),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('dd MMM, hh:mm a').format(n.timestamp),
                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text("No new notifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Text("We'll notify you when something important happens.", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}
