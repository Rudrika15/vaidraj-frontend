import 'package:flutter/material.dart';
import 'package:vaidraj/models/delete_notification_model.dart';
import 'package:vaidraj/services/notifications/delete_notification.dart';

class DeleteNotificationProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DeleteNotificationsService service = DeleteNotificationsService();
  DeleteNotificationModel? _deleteNotificationModel;
  DeleteNotificationModel? get deleteNotificationModel =>
      _deleteNotificationModel;
  Future<bool> deleteNotification(
      {required BuildContext context, required String id}) async {
    _isLoading = true;
    notifyListeners();
    _deleteNotificationModel = null;
    _deleteNotificationModel =
        await service.deleteNotifications(context: context, id: id);
    if (_deleteNotificationModel?.success == true) {
      _isLoading = false;
      return true;
    }
    _isLoading = false;
    return false;
  }
}
