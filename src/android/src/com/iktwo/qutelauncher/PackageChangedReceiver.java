package com.iktwo.qutelauncher;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class PackageChangedReceiver extends BroadcastReceiver {
    public static long qtObject = 0;

    @Override
    public void onReceive(final Context context, Intent intent) {
        final String packageName = intent.getData().getSchemeSpecificPart();

        if (packageName == null || packageName.length() == 0) {
            // they sent us a bad intent
            return;
        }

        final String action = intent.getAction();

        if (action.equals("android.intent.action.PACKAGE_ADDED")) {
            if (QuteLauncher.isApplaunchable(packageName))
                jpackageAdded(QuteLauncher.getApplicationLabel(packageName), packageName, qtObject);
        } else if (action.equals("android.intent.action.PACKAGE_REMOVED")) {
            jpackageRemoved(packageName, qtObject);
        }

    }

    public static void setQtObject(long qtObject2) {
        qtObject = qtObject2;
    }

    private static native void jpackageAdded(String label, String packageName, long qtObject);
    private static native void jpackageRemoved(String packageName, long qtObject);
}
