import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mailing/Pages_File/Setting_Page.dart';
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
            'Basic YjczZWE0MDEtNGIxZi00Y2U3LTk3MDItOGFjMTg4ZWQ3ZDA0',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": "a2e05d33-3eed-4ec0-8961-d5df96631789",
        "contents": {en_ar: content},
        "headings": {en_ar: heading},
        "large_icon": "https://sales-mangment.000webhostapp.com/Mailing_API/Image_File/logo.png",
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
        'Basic YjczZWE0MDEtNGIxZi00Y2U3LTk3MDItOGFjMTg4ZWQ3ZDA0',
      },
      body: jsonEncode(<String, dynamic>{
        "app_id": "a2e05d33-3eed-4ec0-8961-d5df96631789",
        "contents": {en_ar: content},
        "headings": {en_ar: heading},
        "large_icon": "https://sales-mangment.000webhostapp.com/Mailing_API/Image_File/logo.png",
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
        (OSNotificationReceivedEvent event) async {
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
