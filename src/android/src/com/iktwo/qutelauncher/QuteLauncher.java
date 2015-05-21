package com.iktwo.qutelauncher;

import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.io.ByteArrayOutputStream;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.content.res.Resources;
import android.util.Log;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.Uri;
import android.os.Environment;
import android.os.Bundle;
import android.graphics.drawable.Drawable;
import android.graphics.Bitmap;
import android.graphics.drawable.BitmapDrawable;
import android.app.WallpaperManager;
import android.provider.Settings;
import android.util.DisplayMetrics;

import com.iktwo.qutelauncher.R;

public class QuteLauncher extends org.qtproject.qt5.android.bindings.QtActivity {
    final int APPWIDGET_HOST_ID = 2048;
    final int REQUEST_PICK_APPWIDGET = 0;
    final int REQUEST_CREATE_APPWIDGET = 5;

    private static final String TAG = "QuteLauncher";
    private static ConnectivityManager cm;
    private static QuteLauncher m_instance;
    private static WallpaperManager wm;
    private static int mIconDpi;

    private static PackageManager mPm;

    public static String connectionType() {
        cm = (ConnectivityManager) m_instance.getSystemService(CONNECTIVITY_SERVICE);
        NetworkInfo netInfo = cm.getActiveNetworkInfo();
        return netInfo.getTypeName();
    }

    @Override
    protected void onStart() {
        super.onStart();
        m_instance = this;

        ActivityManager activityManager = (ActivityManager) m_instance.getSystemService(Context.ACTIVITY_SERVICE);
        mIconDpi = activityManager.getLauncherLargeIconDensity();

        mPm = (PackageManager) m_instance.getPackageManager();
    }

    public static boolean isApplaunchable(String packageName) {
        return (mPm.getLaunchIntentForPackage(packageName) != null);
    }

    public static int getDPI()
    {
        DisplayMetrics dm = m_instance.getResources().getDisplayMetrics();
        return dm.densityDpi;
    }

    public static boolean isTablet()
    {
        return m_instance.getResources().getBoolean(R.bool.isTablet);
    }

    @Override
    protected void onDestroy() {
        System.exit(0);
    }

    public static QuteLauncher getInstance() {
        return m_instance;
    }

    public QuteLauncher() {
        m_instance = this;
    }

    public static Application[] applications() {
        Log.d(TAG, "PM:" + mPm.toString());
        List<ApplicationInfo> packages = mPm.getInstalledApplications(0);
        Collections.sort(packages, new ApplicationInfo.DisplayNameComparator(mPm));
        List<ApplicationInfo> apps = new ArrayList<ApplicationInfo>();

        for (int i = 0; i < packages.size(); i++) {
            String pkg = packages.get(i).packageName;

            // only apps which are launchable
            if (isApplaunchable(pkg)) {
                apps.add(packages.get(i));
            }
        }

        Application[] appArray = new Application[apps.size()];
        for (int i = 0; i < apps.size(); i++) {
            appArray[i] = new Application(getApplicationLabel(apps.get(i).packageName), apps.get(i).packageName);
        }

        for (int i = 0; i < appArray.length; i++) {
            if (appArray[i].name.length() > 0 && (Character.isSpaceChar(appArray[i].name.charAt(0)) || Character.isWhitespace(appArray[i].name.charAt(0)))) {
                char charToReplace = appArray[i].name.charAt(0);
                appArray[i].setName(appArray[i].name.replace(charToReplace, ' ').trim());
                appArray[i].setName(appArray[i].name.trim());
            }
        }

        for (int i = 0; i < appArray.length; i++) {
            Log.d(TAG, "APPLICATION" + i + " NAME: " + appArray[i].name);
        }

        Arrays.sort(appArray);

        Log.e(TAG, "AFTER SORT");

        for (int i = 0; i < appArray.length; i++) {
            Log.d(TAG, "APPLICATION" + i + " NAME: " + appArray[i].name);
        }

        return appArray;
    }

    public static void launchApplication(String packageName) {
        Intent intent = mPm.getLaunchIntentForPackage(packageName);

        if (intent != null) {
            m_instance.startActivity(intent);
        }
    }

    public static byte[] getApplicationIcon(String packageName) {
         Log.d(TAG, "TRYING TO GET ICON FOR: " + packageName);

        Drawable icon;

        try
        {
            Log.d(TAG, "package manager" + mPm.toString());
            ApplicationInfo app = mPm.getApplicationInfo(packageName, 0);
            Resources resources = mPm.getResourcesForApplication(app);
            ResolveInfo resolveInfo = mPm.resolveActivity(mPm.getLaunchIntentForPackage(packageName), 0);
            Log.d(TAG, "RESOLVEINFO:" + resolveInfo.toString());
            Log.d(TAG, "RESOURCES:" + resources.toString());
            icon = resources.getDrawableForDensity(resolveInfo.activityInfo.getIconResource(), mIconDpi);
        } catch(Exception e)
        {
             Log.e(TAG, "exception getApplicationIcon for " + packageName, e);
             icon = null;
            //return new byte[0];
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
        try
        {
            ApplicationInfo app = mPm.getApplicationInfo(packageName, 0);

            Resources resources = mPm.getResourcesForApplication(app);
            ResolveInfo resolveInfo = mPm.resolveActivity(mPm.getLaunchIntentForPackage(packageName), 0);

            return resolveInfo.loadLabel(mPm).toString();
        } catch(Exception e)
        {
            Log.e(TAG, "getApplicationLabel for " + packageName, e);
            return "";
        }
    }

    public static void pickWallpaper() {
        Intent intent = new Intent(Intent.ACTION_SET_WALLPAPER);
        m_instance.startActivity(Intent.createChooser(intent, "Select Wallpaper"));
    }


    public static byte[] getSystemWallpaper() {
        wm = WallpaperManager.getInstance(m_instance);
        Drawable icon = wm.getDrawable();
        Bitmap bitmap = ((BitmapDrawable)icon).getBitmap();
        ByteArrayOutputStream stream = new ByteArrayOutputStream();
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream);
        byte[] iconData = stream.toByteArray();
        return iconData;
    }

    public static void openApplicationInfo(String packageName) {
        Intent intent = new Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
        intent.setData(Uri.parse("package:" + packageName));
        m_instance.startActivity(intent);
    }

}

class Application implements Comparable<Application>{
        public String packageName;
        public String name;

        public Application(String name, String packageName) {
            this.name = name;
            this.packageName = packageName;
        }

        public String getName() {
            return name;
        }

        public String getPackageName() {
            return packageName;
        }

        public void setName(String name2) {
            name = name2;
        }

        public void setPackageName(String packageName2) {
            packageName = packageName2;
        }

        public int compareTo(Application application) {
            return this.getName().toUpperCase().compareTo(application.getName().toUpperCase());
        }
}
