import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/notification_service.dart';

class NotificationsScreen extends StatefulWidget {
  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _notificationService = NotificationService();
  List<Map<String, dynamic>> notifications = [];
  String selectedFilter = 'Toutes';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    setState(() {
      notifications = _notificationService.getNotificationHistory();
    });
  }

  List<Map<String, dynamic>> get filteredNotifications {
    if (selectedFilter == 'Toutes') return notifications;
    return notifications.where((n) => n['category'] == selectedFilter.toLowerCase()).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredNotifications;
    
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('Notifications'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.mark_email_read),
            onPressed: _markAllAsRead,
          ),
        ],
      ),
      body: Column(
        children: [
          // Filtres
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ['Toutes', 'Hotel', 'Booking', 'Personal'].map((filter) {
                  final isSelected = selectedFilter == filter;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) => setState(() => selectedFilter = filter),
                      backgroundColor: Colors.grey.shade100,
                      selectedColor: Colors.blue.shade100,
                      checkmarkColor: Colors.blue.shade600,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          
          // Liste des notifications
          Expanded(
            child: filtered.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      return _buildNotificationCard(filtered[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _sendTestNotification,
        backgroundColor: Colors.blue.shade600,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none, size: 64, color: Colors.grey.shade400),
          SizedBox(height: 16),
          Text(
            'Aucune notification',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade600,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Vos notifications apparaîtront ici',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    final isRead = notification['read'] as bool;
    final timestamp = notification['timestamp'] as DateTime;
    final timeAgo = _getTimeAgo(timestamp);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isRead ? Colors.white : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isRead ? Colors.grey.shade200 : Colors.blue.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getNotificationColor(notification['type']),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getNotificationIcon(notification['type']),
            color: Colors.white,
            size: 20,
          ),
        ),
        title: Text(
          notification['title'],
          style: TextStyle(
            fontWeight: isRead ? FontWeight.w500 : FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              notification['body'],
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            SizedBox(height: 8),
            Text(
              timeAgo,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
        trailing: !isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () => _markAsRead(notification),
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'promotion':
      case 'price':
      case 'price_alert':
        return Colors.green;
      case 'urgency':
      case 'reminder':
        return Colors.orange;
      case 'luxury':
      case 'reward':
      case 'gift':
        return Colors.purple;
      case 'confirmation':
      case 'booking_confirmed':
        return Colors.blue;
      case 'new':
      case 'welcome':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'promotion':
      case 'price':
        return Icons.local_offer;
      case 'recommendation':
        return Icons.star;
      case 'urgency':
        return Icons.access_time;
      case 'luxury':
        return Icons.diamond;
      case 'new':
        return Icons.fiber_new;
      case 'location':
        return Icons.location_on;
      case 'confirmation':
        return Icons.check_circle;
      case 'reminder':
        return Icons.schedule;
      case 'reward':
        return Icons.card_giftcard;
      default:
        return Icons.notifications;
    }
  }

  String _getTimeAgo(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 60) {
      return 'Il y a ${difference.inMinutes}min';
    } else if (difference.inHours < 24) {
      return 'Il y a ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Il y a ${difference.inDays}j';
    } else {
      return DateFormat('dd/MM').format(timestamp);
    }
  }

  void _markAsRead(Map<String, dynamic> notification) {
    setState(() {
      notification['read'] = true;
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var notification in notifications) {
        notification['read'] = true;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Toutes les notifications marquées comme lues'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _sendTestNotification() {
    final newNotification = _notificationService.getRandomNotification();
    setState(() {
      notifications.insert(0, {
        ...newNotification,
        'id': 'test_${DateTime.now().millisecondsSinceEpoch}',
        'timestamp': DateTime.now(),
        'read': false,
        'category': _getCategoryFromType(newNotification['type']!),
      });
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nouvelle notification reçue !'),
        backgroundColor: Colors.blue.shade600,
      ),
    );
  }

  String _getCategoryFromType(String type) {
    if (['confirmation', 'reminder', 'preparation', 'checkin', 'review'].contains(type)) {
      return 'booking';
    } else if (['birthday', 'upgrade', 'gift', 'stats'].contains(type)) {
      return 'personal';
    } else {
      return 'hotel';
    }
  }
}
