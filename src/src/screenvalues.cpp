#include "screenvalues.h"

#include <QScreen>
#include <QGuiApplication>

#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#endif

#include <QDebug>

ScreenValues::ScreenValues(QObject *parent) :
    QObject(parent),
    m_dpi(0),
    m_isTablet(false)
{
    m_dpi = retrieveDpi();

    m_dp = (float) m_dpi / 160;

    setStatusBarHeight(getResourceSize("status_bar_height"));
    setNavigationBarHeight(getResourceSize("navigation_bar_height"));
    setNavigationBarHeightLandscape(getResourceSize("navigation_bar_height_landscape"));

    updateScreenValues();
}

void ScreenValues::updateScreenValues()
{
#ifdef Q_OS_ANDROID
    if (m_system.sdkInt() >= 19) {
        QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative",
                                                                               "activity",
                                                                               "()Landroid/app/Activity;");

        QAndroidJniObject wm = activity.callObjectMethod("getWindowManager", "()Landroid/view/WindowManager;");
        QAndroidJniObject display = wm.callObjectMethod("getDefaultDisplay", "()Landroid/view/Display;");

        QAndroidJniObject realSize = QAndroidJniObject("android/graphics/Point");
        display.callMethod<void>("getRealSize", "(Landroid/graphics/Point;)V", realSize.object());

        QAndroidJniObject displayFrame = QAndroidJniObject("android/graphics/Rect");
        QAndroidJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
        QAndroidJniObject view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        QAndroidJniObject rootView = view.callObjectMethod("getRootView", "()Landroid/view/View;");
        rootView.callMethod<void>("getWindowVisibleDisplayFrame", "(Landroid/graphics/Rect;)V", displayFrame.object());

        if (((int) realSize.getField<jint>("y") - (int) displayFrame.callMethod<jint>("height")) - m_statusBarHeight == 0)
            setNavBarVisible(false);
        else
            setNavBarVisible(true);
    }
#endif
}

int ScreenValues::dpi() const
{
    return m_dpi;
}

void ScreenValues::setDpi(int dpi)
{
    if (m_dpi == dpi)
        return;

    m_dpi = dpi;
    emit dpiChanged();

    setDp((float) m_dpi / 160);
}

float ScreenValues::dp() const
{
    return m_dp;
}

void ScreenValues::setDp(float dp)
{
    if (m_dp == dp)
        return;

    m_dp = dp;
    emit dpChanged();
}

bool ScreenValues::isTablet() const
{
    return m_isTablet;
}

void ScreenValues::setIsTablet(bool isTablet)
{
    if (m_isTablet == isTablet)
        return;

    m_isTablet = isTablet;
    emit isTabletChanged();
}

bool ScreenValues::navBarVisible() const
{
    return m_navBarVisible;
}

int ScreenValues::statusBarHeight() const
{
    return m_statusBarHeight;
}

int ScreenValues::navigationBarHeight() const
{
    return m_navigationBarHeight;
}

int ScreenValues::navigationBarHeightLandscape() const
{
    return m_navigationBarHeightLandscape;
}

void ScreenValues::setStatusBarHeight(int statusBarHeight)
{
    if (m_statusBarHeight == statusBarHeight)
        return;

    m_statusBarHeight = statusBarHeight;
    emit statusBarHeightChanged();
}

void ScreenValues::setNavigationBarHeight(int navigationBarHeight)
{
    if (m_navigationBarHeight == navigationBarHeight)
        return;

    m_navigationBarHeight = navigationBarHeight;
    emit navigationBarHeightChanged();
}

void ScreenValues::setNavigationBarHeightLandscape(int navigationBarHeightLandscape)
{
    if (m_navigationBarHeightLandscape == navigationBarHeightLandscape)
        return;

    m_navigationBarHeightLandscape = navigationBarHeightLandscape;
    emit navigationBarHeightLandscapeChanged();
}

void ScreenValues::setNavBarVisible(bool visible)
{
    if (m_navBarVisible == visible)
        return;

    m_navBarVisible = visible;
    emit navBarVisibleChanged();
}

int ScreenValues::retrieveDpi()
{
#ifdef Q_OS_ANDROID
    QAndroidJniEnvironment env;
    env->PushLocalFrame(9);

    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative",
                                                                           "activity",
                                                                           "()Landroid/app/Activity;");
    jclass activityClass = env->GetObjectClass(activity.object<jobject>());

    jmethodID mIDGetResources = env->GetMethodID(activityClass,
                                                   "getResources",
                                                   "()Landroid/content/res/Resources;");

    jobject resources = env->CallObjectMethod(activity.object<jobject>(), mIDGetResources);
    jclass resourcesClass = env->GetObjectClass(resources);

    jmethodID mIDGetDisplayMetrics = env->GetMethodID(resourcesClass,
                                                      "getDisplayMetrics",
                                                      "()Landroid/util/DisplayMetrics;");

    jobject displayMetrics = env->CallObjectMethod(resources, mIDGetDisplayMetrics);
    jclass displayMetricsClass = env->GetObjectClass(displayMetrics);

    jfieldID fIDDensityDpi = env->GetFieldID(displayMetricsClass, "densityDpi", "I");
    jint densityDpi = env->GetIntField(displayMetrics, fIDDensityDpi);

    int result = (int)densityDpi;

    env->PopLocalFrame(NULL);

    return result;
#else
    return QGuiApplication::primaryScreen()->physicalDotsPerInch();
#endif
}

int ScreenValues::getResourceSize(const QString &resource)
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject activity = QAndroidJniObject::callStaticObjectMethod("org/qtproject/qt5/android/QtNative",
                                                                           "activity",
                                                                           "()Landroid/app/Activity;");

    QAndroidJniObject resources = activity.callObjectMethod("getResources", "()Landroid/content/res/Resources;");

    QAndroidJniObject jName = QAndroidJniObject::fromString(resource);
    QAndroidJniObject jDefType = QAndroidJniObject::fromString("dimen");
    QAndroidJniObject jDefPackage = QAndroidJniObject::fromString("android");

    jint identifier = resources.callMethod<jint>("getIdentifier",
                                                 "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I",
                                                 jName.object<jstring>(),
                                                 jDefType.object<jstring>(),
                                                 jDefPackage.object<jstring>());

    jint size = resources.callMethod<jint>("getDimensionPixelSize",
                               "(I)I", identifier);

    return size;
#else
    return 0;
#endif
}
