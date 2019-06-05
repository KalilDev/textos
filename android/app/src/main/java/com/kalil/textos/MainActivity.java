package com.kalil.textos;

import android.os.Build;
import android.os.Bundle;
import android.view.View;
import android.view.WindowManager;

import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
    private NotificationUtils mNotificationUtils;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
                WindowManager.LayoutParams.FLAG_FULLSCREEN);
        int uiOptions;
        if (Build.VERSION.SDK_INT > 19) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                uiOptions=View.SYSTEM_UI_FLAG_IMMERSIVE;
            } else {
                uiOptions=View.SYSTEM_UI_FLAG_IMMERSIVE;
            }
        } else {
            uiOptions=View.SYSTEM_UI_FLAG_LAYOUT_STABLE;
        }
        getWindow().getDecorView().setSystemUiVisibility(uiOptions);
        mNotificationUtils = new NotificationUtils(this);
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
    }

}
