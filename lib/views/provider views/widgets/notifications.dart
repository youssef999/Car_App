import 'package:first_project/values/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:first_project/controllers/provider_controller.dart';
import 'package:first_project/models/notification_model.dart';

class NotificationsPage extends StatefulWidget {
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final ProviderController _controller = Get.find();

   @override
  void initState() {
    _controller.fetchNotifications();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (_controller.notifications.isEmpty) {
          return Center(
            child: Text(
              'لا توجد إشعارات'.tr, // "No notifications found" in Arabic
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await _controller.fetchNotifications(); // Refresh notifications
          },
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: _controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = _controller.notifications[index];
              return _buildNotificationCard(notification);
            },
          ),
        );
      }),
    );
  }

  Widget _buildNotificationCard(NotificationModel notification) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notification Title
            Row(
              children: [
                const Icon(Icons.notifications, color: Colors.blue), // Notification icon
                const SizedBox(width: 8), // Spacing
                Text(
                  'تأكيد طلب جديد'.tr, // "New Order Confirmation" in Arabic
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8), // Spacing

            // Divider
            Divider(color: Colors.grey[300]),

            // Notification Details
            _buildDetailRow(Icons.access_time, 'الوقت: ${DateFormat('HH:mm').format(notification.timestamp)}'.tr),
            _buildDetailRow(Icons.directions_car, 'حجم السيارة: ${notification.carSize}'.tr),
            _buildDetailRow(Icons.location_on, 'مكان التحميل: ${notification.placeOfLoading}'.tr),
            _buildDetailRow(Icons.place, 'الوجهة: ${notification.destination}'.tr),

            // Status and Action Button
            const SizedBox(height: 16), // Spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status Indicator
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                //   decoration: BoxDecoration(
                //     color: notification.status == 'pending'
                //         ? Colors.orange[100]
                //         : Colors.green[100],
                //     borderRadius: BorderRadius.circular(20),
                //   ),
                //   child: Text(
                //     notification.status == 'pending' ? 'قيد الانتظار'.tr : 'تم التأكيد'.tr,
                //     style: TextStyle(
                //       color: notification.status == 'pending'
                //           ? Colors.orange[800]
                //           : Colors.green[800],
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),

                // Confirm Button
                Center(
                  child: ElevatedButton(
                    onPressed: () => _controller.confirmOrder(notification.orderId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor, // Button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                    ),
                    child: Text(
                      'confirm'.tr, // "Confirm" in Arabic
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build a detail row with an icon and text
  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8), // Spacing
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}