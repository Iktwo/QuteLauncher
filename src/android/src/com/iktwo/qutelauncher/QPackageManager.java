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
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetHost;
import android.appwidget.AppWidgetProviderInfo;
import android.appwidget.AppWidgetHostView;
import android.util.DisplayMetrics;

import com.iktwo.qutelauncher.R;

public class QPackageManager extends org.qtproject.qt5.android.bindings.QtActivity {
    final int APPWIDGET_HOST_ID = 2048;
    final int REQUEST_PICK_APPWIDGET = 0;
    final int REQUEST_CREATE_APPWIDGET = 5;

//    AppWidgetManager appWidgetManager;
//    AppWidgetHost appWidgetHost;

    private static final String TAG = "QPackageManager";
    private static ConnectivityManager cm;
    private static QPackageManager m_instance;
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


//    @Override
//    protected void onRestart() {
//        super.onStart();
//        m_instance = this;
//    }

//    @Override
//    protected void onConfigurationChanged() {
//        super.onConfigurationChanged();

//    }

    /// TODO: fix this horrible bug
//    @Override
//    protected void onPause() {
//        finish();
//        super.onPause();
//    }

    @Override
    protected void onDestroy() {
        System.exit(0);
    }




//    @Override
//    protected void onStart() {
//        super.onStart();
//        appWidgetManager = AppWidgetManager.getInstance(this);
//        appWidgetHost = new AppWidgetHost(this, APPWIDGET_HOST_ID);

//        // Start listening to pending intents from the widgets
//        appWidgetHost.startListening();
//    }

//    @Override
//    protected void onStop() {
//        super.onStop();
//        appWidgetHost.stopListening();
//    }

//    public void selectWidget()
//    {
//        int appWidgetId = this.appWidgetHost.allocateAppWidgetId();
//        Intent pickIntent = new Intent(AppWidgetManager.ACTION_APPWIDGET_PICK);
//        pickIntent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
//        addEmptyData(pickIntent);
//        startActivityForResult(pickIntent, REQUEST_PICK_APPWIDGET);
//    }

//    @Override
//    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
//        if (resultCode == RESULT_OK) {
//            if (requestCode == REQUEST_PICK_APPWIDGET) {
//                configureWidget(data);
//            } else if (requestCode == REQUEST_CREATE_APPWIDGET) {
//                createWidget(data);
//            }
//        } else if (resultCode == RESULT_CANCELED && data != null) {
//            int appWidgetId =
//                data.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, -1);
//            if (appWidgetId != -1) {
//                appWidgetHost.deleteAppWidgetId(appWidgetId);
//            }
//        }
//    }

//    // Show configuration activity of the widget picked by the user
//    private void configureWidget(Intent data) {
//        Bundle extras = data.getExtras();
//        int appWidgetId = extras.getInt(AppWidgetManager.EXTRA_APPWIDGET_ID, -1);
//        AppWidgetProviderInfo appWidgetInfo =
//                appWidgetManager.getAppWidgetInfo(appWidgetId);
//        if (appWidgetInfo.configure != null) {
//            Intent intent =
//                new Intent(AppWidgetManager.ACTION_APPWIDGET_CONFIGURE);
//            intent.setComponent(appWidgetInfo.configure);
//            intent.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId);
//            startActivityForResult(intent, REQUEST_CREATE_APPWIDGET);
//        } else {
//            createWidget(data);
//        }
//    }

//    // Get an instance of the selected widget as a AppWidgetHostView
//    public void createWidget(Intent data) {
//        Bundle extras = data.getExtras();
//        int appWidgetId = extras.getInt(AppWidgetManager.EXTRA_APPWIDGET_ID, -1);
//        AppWidgetProviderInfo appWidgetInfo = appWidgetManager.getAppWidgetInfo(appWidgetId);

//        AppWidgetHostView hostView = appWidgetHost.createView(this, appWidgetId, appWidgetInfo);
//        hostView.setAppWidget(appWidgetId, appWidgetInfo);
//        // Add  it on the layout you want
//        //myLayout.addView(hostView);
//    }


    // For some reason you have to add this empty data, else it won't work
    public void addEmptyData(Intent pickIntent)
    {
        ArrayList<AppWidgetProviderInfo> customInfo = new ArrayList<AppWidgetProviderInfo>();
        pickIntent.putParcelableArrayListExtra(AppWidgetManager.EXTRA_CUSTOM_INFO, customInfo);
        ArrayList<Bundle> customExtras = new ArrayList<Bundle>();
        pickIntent.putParcelableArrayListExtra(AppWidgetManager.EXTRA_CUSTOM_EXTRAS, customExtras);
    }

    public static QPackageManager getInstance() {
        return m_instance;
    }

    public QPackageManager() {
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
