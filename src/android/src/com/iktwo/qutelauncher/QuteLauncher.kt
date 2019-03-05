package com.iktwo.qutelauncher

import android.app.ActivityManager
import android.app.WallpaperManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.AdaptiveIconDrawable
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.graphics.drawable.LayerDrawable
import android.net.ConnectivityManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.util.Log
import android.view.View
import java.io.ByteArrayOutputStream

open class QuteLauncher : org.qtproject.qt5.android.bindings.QtActivity() {
    init {
        instance = this
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        this.QT_ANDROID_DEFAULT_THEME = "AppTheme"

        super.onCreate(savedInstanceState)

        getWindow().getDecorView().setSystemUiVisibility(
                View.SYSTEM_UI_FLAG_LAYOUT_STABLE
                        or View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
                        or View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION)
    }

    override fun onStart() {
        super.onStart()
        instance = this

        val activityManager = instance!!.getSystemService(Context.ACTIVITY_SERVICE) as ActivityManager
        mIconDpi = activityManager.launcherLargeIconDensity

        mPm = instance!!.getPackageManager() as PackageManager
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        jnewIntent(qtObject)
    }

    companion object {
        private val TAG = "QuteLauncher"
        private var cm: ConnectivityManager? = null
        var instance: QuteLauncher? = null
            private set
        private val wm: WallpaperManager? = null
        private var mIconDpi: Int = 0
        private var mPm: PackageManager? = null
        private var qtObject: Long = 0

        fun connectionType(): String {
            cm = instance!!.getSystemService(CONNECTIVITY_SERVICE) as ConnectivityManager
            val netInfo = cm!!.activeNetworkInfo
            return netInfo.typeName
        }

        fun isApplaunchable(packageName: String): Boolean {
            return mPm!!.getLaunchIntentForPackage(packageName) != null
        }

        val dpi: Int
            get() {
                val dm = instance!!.getResources().getDisplayMetrics()
                return dm.densityDpi
            }

        @JvmStatic
        fun applications(): Array<Application> {
            val intent = Intent(Intent.ACTION_MAIN, null)
            intent.addCategory(Intent.CATEGORY_LAUNCHER)
            val availableActivities = mPm!!.queryIntentActivities(intent, 0)

            val applications = mutableListOf<Application>()

            for (i in availableActivities.indices) {
                applications.add(Application(availableActivities[i].loadLabel(mPm).toString(), availableActivities[i].activityInfo.packageName))
            }

            for (i in applications.indices) {
                if (applications[i].name.isNotEmpty() && (Character.isSpaceChar(applications[i].name[0]) || Character.isWhitespace(applications[i].name[0]))) {
                    val charToReplace = applications[i].name[0]
                    applications[i].name = applications[i].name.replace(charToReplace, ' ').trim { it <= ' ' }
                    applications[i].name = applications[i].name.trim { it <= ' ' }
                }
            }

            applications.sort()

            return applications.toTypedArray()
        }

        @JvmStatic
        fun launchApplication(packageName: String) {
            val intent = mPm!!.getLaunchIntentForPackage(packageName)

            if (intent != null) {
                instance!!.startActivity(intent)
            }
        }

        @JvmStatic
        fun getApplicationIcon(packageName: String): ByteArray {
            var icon: Drawable?

            try {
                val app = mPm!!.getApplicationInfo(packageName, 0)
                val resources = mPm!!.getResourcesForApplication(app)
                val resolveInfo = mPm!!.resolveActivity(mPm!!.getLaunchIntentForPackage(packageName), 0)
                icon = resources.getDrawableForDensity(resolveInfo.activityInfo.iconResource, mIconDpi)
            } catch (e: Exception) {
                Log.e(TAG, "exception getApplicationIcon for $packageName", e)
                icon = null
            }

            if (icon == null)
                icon = defaultApplicationIcon

            val stream = ByteArrayOutputStream()
            var bitmap: Bitmap? = null

            if (icon is BitmapDrawable) {
                bitmap = icon.bitmap
            } else {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    if (icon is AdaptiveIconDrawable) {
                        val arrayOfDrawables = arrayOf(icon.background, icon.foreground)
                        val layerDrawable = LayerDrawable(arrayOfDrawables)

                        bitmap = Bitmap.createBitmap(layerDrawable.intrinsicWidth, layerDrawable.intrinsicHeight, Bitmap.Config.ARGB_8888)

                        val canvas = Canvas(bitmap)

                        layerDrawable.setBounds(0, 0, canvas.width, canvas.height)
                        layerDrawable.draw(canvas)
                    } else {
                        bitmap = (defaultApplicationIcon as BitmapDrawable).bitmap
                    }
                } else {
                    bitmap = (defaultApplicationIcon as BitmapDrawable).bitmap
                }
            }

            bitmap?.compress(Bitmap.CompressFormat.PNG, 100, stream)
            return stream.toByteArray()
        }

        val defaultApplicationIcon: Drawable
            get() = instance!!.getResources().getDrawable(android.R.mipmap.sym_def_app_icon)

        @JvmStatic
        fun getApplicationLabel(packageName: String): String {
            try {
                val app = mPm!!.getApplicationInfo(packageName, 0)

                val resources = mPm!!.getResourcesForApplication(app)
                val resolveInfo = mPm!!.resolveActivity(mPm!!.getLaunchIntentForPackage(packageName), 0)

                return resolveInfo.loadLabel(mPm).toString()
            } catch (e: Exception) {
                Log.e(TAG, "getApplicationLabel for $packageName", e)
                return ""
            }

        }

        fun pickWallpaper() {
            val intent = Intent(Intent.ACTION_SET_WALLPAPER)
            instance!!.startActivity(Intent.createChooser(intent, "Select Wallpaper"))
        }

        fun openApplicationInfo(packageName: String) {
            val intent = Intent(android.provider.Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
            intent.data = Uri.parse("package:$packageName")
            instance!!.startActivity(intent)
        }

        fun setQtObject(qtObject: Long) {
            QuteLauncher.qtObject = qtObject
        }

        @JvmStatic
        private external fun jnewIntent(qtObject: Long)
    }
}
