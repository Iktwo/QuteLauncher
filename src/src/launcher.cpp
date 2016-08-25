#include "launcher.h"

#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>

static void newIntent(JNIEnv *env, jobject thiz, jlong qtObject)
{
    Q_UNUSED(env)
    Q_UNUSED(thiz)
    reinterpret_cast<Launcher*>(qtObject)->emitNewIntent();
}
#endif

Launcher::Launcher(QObject *parent) : QObject(parent)
{
#ifdef Q_OS_ANDROID
    mActivity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative", "activity", "()Landroid/app/Activity;");

#endif
}

void Launcher::pickWallpaper()
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("com/iktwo/qutelauncher/QuteLauncher",
                                              "pickWallpaper",
                                              "()V");
#endif
}

void Launcher::emitNewIntent()
{
    emit newIntentReceived();
}

void Launcher::registerMethods()
{
    registerNativeMethods();
}

void Launcher::registerNativeMethods()
{
#ifdef Q_OS_ANDROID
    JNINativeMethod methods[] {{"jnewIntent", "(J)V", reinterpret_cast<void *>(newIntent)}};

    QAndroidJniObject::callStaticMethod<void>("com/iktwo/qutelauncher/QuteLauncherFlavored",
                                              "setQtObject", "(J)V",
                                              "(J)V", reinterpret_cast<long>(this));

    QAndroidJniEnvironment env;
    jclass objectClass = env->GetObjectClass(mActivity.object<jobject>());

    if (env->ExceptionCheck())
        env->ExceptionClear();

    env->RegisterNatives(objectClass, methods, sizeof(methods) / sizeof(methods[0]));

    if (env->ExceptionCheck())
        env->ExceptionClear();

    env->DeleteLocalRef(objectClass);

    if (env->ExceptionCheck())
        env->ExceptionClear();
#endif
}
