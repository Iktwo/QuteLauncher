package com.iktwo.qutelauncher

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent

class PackageChangedReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context, intent: Intent) {
        val packageName = intent.data!!.schemeSpecificPart

        if (packageName == null || packageName.isEmpty()) {
            return
        }

        val action = intent.action

        if (action == "android.intent.action.PACKAGE_ADDED") {
            if (QuteLauncher.isApplaunchable(packageName))
                jpackageAdded(QuteLauncher.getApplicationLabel(packageName), packageName, internalQtObject)
        } else if (action == "android.intent.action.PACKAGE_REMOVED") {
            jpackageRemoved(packageName, internalQtObject)
        }

    }

    companion object {
        @JvmStatic
        var internalQtObject: Long = 0

        @JvmStatic
        fun setQtObject(qtObject2: Long) {
            internalQtObject = qtObject2
        }

        @JvmStatic
        private external fun jpackageAdded(label: String, packageName: String, qtObject: Long)

        @JvmStatic
        private external fun jpackageRemoved(packageName: String, qtObject: Long)
    }
}
