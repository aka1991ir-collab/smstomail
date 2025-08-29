package your.package.name;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.telephony.SmsMessage;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.embedding.engine.FlutterEngine;

public class SmsReceiver extends BroadcastReceiver {
    private static MethodChannel channel;

    public static void registerWith(FlutterEngine engine) {
        channel = new MethodChannel(engine.getDartExecutor().getBinaryMessenger(), "sms_listener");
    }

    @Override
    public void onReceive(Context context, Intent intent) {
        Bundle bundle = intent.getExtras();
        if (bundle != null) {
            Object[] pdus = (Object[]) bundle.get("pdus");
            if (pdus != null) {
                for (Object pdu : pdus) {
                    SmsMessage sms = SmsMessage.createFromPdu((byte[]) pdu);
                    String sender = sms.getDisplayOriginatingAddress();
                    String body = sms.getMessageBody();
                    if (channel != null) {
                        java.util.HashMap<String, String> args = new java.util.HashMap<>();
                        args.put("sender", sender);
                        args.put("body", body);
                        channel.invokeMethod("onSmsReceived", args);
                    }
                }
            }
        }
    }
}
