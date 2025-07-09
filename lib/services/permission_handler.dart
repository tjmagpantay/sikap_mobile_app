import 'package:permission_handler/permission_handler.dart';

Future<bool> requestNotificationPermission() async {
  var status = await Permission.notification.request();
  return status.isGranted;
}