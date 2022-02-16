import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mailing/Validate.dart';
import 'package:mailing/main.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class Notification_OneSignal_class {
  static String _debugLabelString = "";

  static Future<void> handleSendNotificationWithImage(
      String image, String content, String heading) async {
    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) return;
    var playerId = deviceState.userId!;
    var imgUrlString = image;

    var response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'Basic NDFkMGE0ZjUtYjdjYi00MDExLTg4NDktZTU0Y2FiMWFlZmNl',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": "cc6f0e3f-bea7-478c-a743-230d2640c689",
        "contents": {en_ar: content},
        "headings": {en_ar: heading},
        "big_picture": imgUrlString,
        "included_segments": ["All"]
      }),
    );
    print(response.statusCode);
  }
  static Future<void> handleSendNotification(String content, String heading) async {
    var deviceState = await OneSignal.shared.getDeviceState();

    if (deviceState == null || deviceState.userId == null) return;

    var response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
        'Basic NDFkMGE0ZjUtYjdjYi00MDExLTg4NDktZTU0Y2FiMWFlZmNl',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": "cc6f0e3f-bea7-478c-a743-230d2640c689",
        "contents": {en_ar: content},
        "headings": {en_ar: heading},
        "included_segments": ["All"]
      }),
    );
    print(response.statusCode);
  }

  static void setExternalUser(String deviceId) {
// Setting External User Id with Callback Available in SDK Version 3.9.3+
    OneSignal.shared.setExternalUserId(deviceId).then((results) {
      print(results.toString());
    }).catchError((error) {
      print(error.toString());
    });
  }

  static void callback_before_notifi() {
    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
      // Display Notification, send null to not display, send notification to display
      event.complete(event.notification);
    });
  }

  static void open_notifi() {
    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('"OneSignal: notification opened: ${result}');
    });
  }
}
