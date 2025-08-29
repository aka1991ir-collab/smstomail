import 'package:flutter/services.dart';

class SmsListener {
  static const MethodChannel _channel = MethodChannel('sms_listener');

  static void startListening(Function(String, String) onSmsReceived) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onSmsReceived') {
        final sender = call.arguments['sender'] ?? '';
        final body = call.arguments['body'] ?? '';
        onSmsReceived(sender, body);
      }
    });
  }
}
