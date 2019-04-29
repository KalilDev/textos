package com.kalil.textos;

import android.annotation.TargetApi;
import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.ContextWrapper;
import android.graphics.Color;

@TargetApi(26)
public class NotificationUtils extends ContextWrapper {

    public final String NEW_TEXTS_CHANNEL_ID = getString(R.string.new_texts_notification_channel_id);
    public final String COMEBACK_CHANNEL_ID = getString(R.string.comeback_notification_channel_id);
    public final String NEW_TEXTS_CHANNEL_NAME = getString(R.string.new_texts_notification_channel_name);
    public final String COMEBACK_CHANNEL_NAME = getString(R.string.comeback_notification_channel_name);
    private NotificationManager mManager;

    public NotificationUtils(Context base) {
        super(base);
        createChannels();
    }

    public void createChannels() {
        // Create new texts channel
        NotificationChannel newTextsChannel = new NotificationChannel(NEW_TEXTS_CHANNEL_ID,
                NEW_TEXTS_CHANNEL_NAME, NotificationManager.IMPORTANCE_HIGH);
        newTextsChannel.enableLights(true);
        newTextsChannel.enableVibration(true);
        newTextsChannel.setLightColor(Color.BLUE);
        newTextsChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);

        getManager().createNotificationChannel(newTextsChannel);

        // Create comeback channel
        NotificationChannel comebackChannel = new NotificationChannel(COMEBACK_CHANNEL_ID,
                COMEBACK_CHANNEL_NAME, NotificationManager.IMPORTANCE_LOW);
        comebackChannel.enableLights(false);
        comebackChannel.enableVibration(true);
        comebackChannel.setLockscreenVisibility(Notification.VISIBILITY_PUBLIC);
        getManager().createNotificationChannel(comebackChannel);
    }

    private NotificationManager getManager() {
        if (mManager == null) {
            mManager = (NotificationManager) getSystemService(Context.NOTIFICATION_SERVICE);
        }
        return mManager;
    }
}
