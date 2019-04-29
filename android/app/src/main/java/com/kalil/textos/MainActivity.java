package com.kalil.textos;

import android.os.Bundle;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private NotificationUtils mNotificationUtils;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        mNotificationUtils = new NotificationUtils(this);
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
    }
}
