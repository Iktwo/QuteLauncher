package com.iktwo.qutelauncher;

import android.app.ActivityManager;
import android.app.WallpaperManager;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.View;

import java.io.ByteArrayOutputStream;
import java.util.Arrays;
import java.util.List;

public class QuteLauncher extends org.qtproject.qt5.android.bindings.QtActivity {
    private static final String TAG = "QuteLauncher";
    private static ConnectivityManager cm;
    private static QuteLauncher m_instance;
    private static WallpaperManager wm;
    private static int mIconDpi;
    private static PackageManager mPm;
    private static long qtObject = 0;

    public QuteLauncher() {
        m_instance = this;
    }

    public static String connectionType() {
        cm = (ConnectivityManager) m_instance.getSystemService(CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();
        return netInfo.getTypeName();
    }

    public static boolean isApplaunchable(String packageName) {
        return (mPm.getLaunchIntentForPackage(packageName) != null);
    }

    public static int getDPI() {
        DisplayMetrics dm = m_instance.getResources().getDisplayMetrics();
        return dm.densityDpi;
    }

    public static QuteLauncher getInstance() {
        return m_instance;
    }

    public static Application[] applications() {
        Intent intent = new Intent(Intent.ACTION_MAIN, null);
        intent.addCategory(Intent.CATEGORY_LAUNCHER);
        List<ResolveInfo> availableActivities = mPm.queryIntentActivities(intent, 0);

        Application[] appArray = new Application[availableActivities.size()];

        for (int i = 0; i < availableActivities.size(); i++) {
            appArray[i] = new Application(availableActivities.get(i).loadLabel(mPm).toString(), availableActivities.get(i).activityInfo.packageName);
        }

        for (int i = 0; i < appArray.length; i++) {
            if (appArray[i].name.length() > 0 && (Character.isSpaceChar(appArray[i].name.charAt(0)) || Character.isWhitespace(appArray[i].name.charAt(0)))) {
                char charToReplace = appArray[i].name.charAt(0);
                appArray[i].setName(appArray[i].name.replace(charToReplace, ' ').trim());
                appArray[i].setName(appArray[i].name.trim());
            }
        }

        Arrays.sort(appArray);

        return appArray;
    }

    public static void launchApplication(String packageName) {
        Intent intent = mPm.getLaunchIntentForPackage(packageName);

        if (intent != null) {
            m_instance.startActivity(intent);
        }
    }

    public static byte[] getApplicationIcon(String packageName) {
        // Log.d(TAG, "TRYING TO GET ICON FOR: " + packageName);

        Drawable icon;

        /// Get application icon
        try {
            ApplicationInfo app = mPm.getApplicationInfo(packageName, 0);
            Resources resources = mPm.getResourcesForApplication(app);
            ResolveInfo resolveInfo = mPm.resolveActivity(mPm.getLaunchIntentForPackage(packageName), 0);
            icon = resources.getDrawableForDensity(resolveInfo.activityInfo.getIconResource(), mIconDpi);
        } catch (Exception e) {
            Log.e(TAG, "exception getApplicationIcon for " + packageName, e);
            icon = null;
        }

        if (icon == null)
            icon = getDefaultApplicationIcon();

        Bitmap bitmap = ((BitmapDrawable) icon).getBitmap();
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
        byte[] iconData = stream.toByteArray();
        return iconData;
    }

    public static Drawable getDefaultApplicationIcon() {
        return m_instance.getResources().getDrawable(android.R.mipmap.sym_def_app_icon);
    }

    public static String getApplicationLabel(String packageName) {
        try {
            ApplicationInfo app = mPm.getApplicationInfo(packageName, 0);

            Resources resources = mPm.getResourcesForApplication(app);
            ResolveInfo resolveInfo = mPm.resolveActivity(mPm.getLaunchIntentForPackage(packageName), 0);

            return resolveInfo.loadLabel(mPm).toString();
        } catch (Exception e) {
            Log.e(TAG, "getApplicationLabel for " + packageName, e);
            return "";
        }
    }

    public static void pickWallpaper() {
        Intent intent = new Intent(Intent.ACTION_SET_WALLPAPER);
        m_instance.startActivity(Intent.createChooser(intent, "Select Wallpaper"));
    }

    public static void openApplicationInfo(String packageName) {
        Intent intent = new Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        intent.setData(Uri.parse("package:" + packageName));
        m_instance.startActivity(intent);
    }

    public static void setQtObject(long qtObject) {
        QuteLauncher.qtObject = qtObject;
    }

    private static native void jnewIntent(long qtObject);

    @Override
    public void onCreate(Bundle savedInstanceState) {
        this.QT_ANDROID_DEFAULT_THEME = "AppTheme";

        super.onCreate(savedInstanceState);

        getWindow().getDecorView().setSystemUiVisibility(
            View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION);
    }

    @Override
    protected void onStart() {
        super.onStart();
        m_instance = this;

        ActivityManager activityManager = (ActivityManager) m_instance.getSystemService(Context.ACTIVITY_SERVICE);
        mIconDpi = activityManager.getLauncherLargeIconDensity();

        mPm = (PackageManager) m_instance.getPackageManager();
    }

    @Override
    protected void onNewIntent(Intent intent) {
        super.onNewIntent(intent);
        jnewIntent(qtObject);
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        System.exit(0);
    }

}

class Application implements Comparable<Application> {
    public String packageName;
    public String name;

    public Application(String name, String packageName) {
        this.name = name;
        this.packageName = packageName;
    }

    public String getName() {
        return name;
    }

    public void setName(String name2) {
        name = name2;
    }

    public String getPackageName() {
        return packageName;
    }

    public void setPackageName(String packageName2) {
        packageName = packageName2;
    }

    public int compareTo(Application application) {
        return this.getName().toUpperCase().compareTo(application.getName().toUpperCase());
    }
}
