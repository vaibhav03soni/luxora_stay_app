import 'dart:async';

class AppNotification {
  final String id;
  final String title;
  final String body;
  final DateTime timestamp;
  bool isRead;

  AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.isRead = false,
  });
}

abstract class NotificationService {
  Stream<List<AppNotification>> get notifications;
  Future<void> markAsRead(String id);
  Future<void> addNotification(String title, String body);
}

class MockNotificationService implements NotificationService {
  final _controller = StreamController<List<AppNotification>>.broadcast();
  final List<AppNotification> _notifications = [
    AppNotification(
      id: '1',
      title: 'Welcome to Luxora Stay!',
      body: 'Start exploring our premium collection of hotels and resorts.',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    AppNotification(
      id: '2',
      title: 'Special Offer: 20% OFF',
      body: 'Use coupon code WELCOME20 to get 20% off on your first booking.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  MockNotificationService() {
    _controller.add(_notifications);
  }

  @override
  Stream<List<AppNotification>> get notifications => _controller.stream;

  @override
  Future<void> markAsRead(String id) async {
    final index = _notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      _notifications[index].isRead = true;
      _controller.add(_notifications);
    }
  }

  @override
  Future<void> addNotification(String title, String body) async {
    _notifications.insert(0, AppNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      body: body,
      timestamp: DateTime.now(),
    ));
    _controller.add(_notifications);
  }
}
