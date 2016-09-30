package com.iktwo.qutelauncher;

import android.os.Bundle;

import com.google.firebase.analytics.FirebaseAnalytics;

public class QuteLauncherFlavored extends QuteLauncher {
    private FirebaseAnalytics firebaseAnalytics;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        firebaseAnalytics = FirebaseAnalytics.getInstance(this);
    }
}
