import 'package:cloud_billr/main.dart';
import 'package:cloud_billr/utils/theme.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Invoice Paid',
      'message': 'Tech Solutions Inc. paid INV-2024-001 of \$2,500.00.',
      'time': '2 hours ago',
      'type': 'payment_success',
      'isRead': false,
    },
    {
      'id': '2',
      'title': 'Backup Completed',
      'message': 'Your weekly data backup was successfully completed.',
      'time': '5 hours ago',
      'type': 'backup_success',
      'isRead': false,
    },
    {
      'id': '3',
      'title': 'Payment Overdue',
      'message': 'Invoice INV-2024-002 for Design Studio Co is overdue.',
      'time': '1 day ago',
      'type': 'payment_overdue',
      'isRead': true,
    },
    {
      'id': '4',
      'title': 'System Update',
      'message': 'Cloud-Billr version 0.1.0 is now live with stability updates.',
      'time': '3 days ago',
      'type': 'system',
      'isRead': true,
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read.'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  Color _getIconBgColor(String type) {
    switch (type) {
      case 'payment_success':
        return appColors.successGreenBgColor;
      case 'payment_overdue':
        return appColors.pendingYellowBgColor;
      case 'backup_success':
        return appColors.primaryBlueColor;
      case 'system':
      default:
        return appColors.surfaceColor;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'payment_success':
        return appColors.successGreenColor;
      case 'payment_overdue':
        return appColors.pendingYellowColor;
      case 'backup_success':
        return appColors.primaryColor;
      case 'system':
      default:
        return appColors.textColor;
    }
  }

  IconData _getIconData(String type) {
    switch (type) {
      case 'payment_success':
        return Icons.check_circle_outline;
      case 'payment_overdue':
        return Icons.warning_amber_outlined;
      case 'backup_success':
        return Icons.cloud_done_outlined;
      case 'system':
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: appColors.backgroundColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: appColors.textColor),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Notifications',
          style: TextStyle(
            color: appColors.textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_notifications.any((n) => !n['isRead']))
            TextButton(
              onPressed: _markAllAsRead,
              child: Text(
                'Read All',
                style: TextStyle(
                  color: appColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: _notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none,
                      size: 64,
                      color: appColors.textSecondaryColor.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: AppSpacing.spacingM),
                    Text(
                      'No notifications yet',
                      style: TextStyle(
                        color: appColors.textSecondaryColor,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(AppSpacing.mainPadding),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final notification = _notifications[index];
                  final isRead = notification['isRead'] as bool;
                  final type = notification['type'] as String;

                  return Container(
                    margin: const EdgeInsets.only(bottom: AppSpacing.marginMedium),
                    padding: const EdgeInsets.all(AppSpacing.paddingMedium),
                    decoration: BoxDecoration(
                      color: isRead ? appColors.backgroundColor : appColors.surfaceColor,
                      borderRadius: AppRadius.medium,
                      border: Border.all(
                        color: isRead ? appColors.borderColor : appColors.primaryColor.withValues(alpha: 0.2),
                        width: isRead ? 1 : 1.5,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: _getIconBgColor(type),
                          child: Icon(
                            _getIconData(type),
                            color: _getIconColor(type),
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    notification['title'] as String,
                                    style: TextStyle(
                                      color: appColors.textColor,
                                      fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    notification['time'] as String,
                                    style: TextStyle(
                                      color: appColors.textSecondaryColor,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                notification['message'] as String,
                                style: TextStyle(
                                  color: isRead ? appColors.textSecondaryColor : appColors.textColor,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
