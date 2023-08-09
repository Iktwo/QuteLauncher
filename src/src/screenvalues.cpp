#include "screenvalues.h"

#include <QScreen>
#include <QGuiApplication>

#ifdef Q_OS_ANDROID
#include <QJniEnvironment>
#include <QJniObject>
#endif

#include <QDebug>

ScreenValues::ScreenValues(QObject *parent) :
    QObject(parent),
    m_dpi(0),
    m_isTablet(false)
{
    m_dpi = retrieveDpi();

    m_density = retrieveDensity();

    m_dp = (float) m_dpi / 160;

    updateScreenValues();

    m_isTablet = retrieveIsTablet();
}

void ScreenValues::updateScreenValues()
{
#ifdef Q_OS_ANDROID
    if (m_system.sdkInt() >= 19) {
        QJniObject activity = QJniObject::callStaticObjectMethod("org/qtproject/qt/android/QtNative",
                                                                               "activity",
                                                                               "()Landroid/app/Activity;");

        QJniObject wm = activity.callObjectMethod("getWindowManager", "()Landroid/view/WindowManager;");
        QJniObject display = wm.callObjectMethod("getDefaultDisplay", "()Landroid/view/Display;");

        QJniObject realSize = QJniObject("android/graphics/Point");
        display.callMethod<void>("getRealSize", "(Landroid/graphics/Point;)V", realSize.object());

        QJniObject displayFrame = QJniObject("android/graphics/Rect");
        QJniObject window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
        QJniObject view = window.callObjectMethod("getDecorView", "()Landroid/view/View;");
        QJniObject rootView = view.callObjectMethod("getRootView", "()Landroid/view/View;");
        rootView.callMethod<void>("getWindowVisibleDisplayFrame", "(Landroid/graphics/Rect;)V", displayFrame.object());

        setStatusBarHeight(getResourceSize("status_bar_height"));
        setNavigationBarHeight(getResourceSize("navigation_bar_height"));
        setNavigationBarHeightLandscape(getResourceSize("navigation_bar_height_landscape"));

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

float ScreenValues::density() const
{
    return m_density;
}

void ScreenValues::setDensity(float density)
{
    if (m_density == density)
        return;

    m_density = density;
    emit densityChanged(density);
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

bool ScreenValues::retrieveIsTablet()
{
#ifdef Q_OS_ANDROID
    QJniEnvironment env;
    env->PushLocalFrame(9);

    QJniObject activity = QJniObject::callStaticObjectMethod("org/qtproject/qt/android/QtNative",
                                                                           "activity",
                                                                           "()Landroid/app/Activity;");

    QJniObject resources = activity.callObjectMethod("getResources",
                                                            "()Landroid/content/res/Resources;");

    QJniObject configuration = resources.callObjectMethod("getConfiguration",
                                                                 "()Landroid/content/res/Configuration;");

    jint smallestScreenWidthDp = configuration.getField<jint>("smallestScreenWidthDp");

    return smallestScreenWidthDp >= 600;
#else
    return false;
#endif
}

int ScreenValues::retrieveDpi()
{
#ifdef Q_OS_ANDROID
    QJniEnvironment env;
    env->PushLocalFrame(9);

    QJniObject activity = QJniObject::callStaticObjectMethod("org/qtproject/qt/android/QtNative",
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

float ScreenValues::retrieveDensity()
{
#ifdef Q_OS_ANDROID
    QJniEnvironment env;
    env->PushLocalFrame(9);

    QJniObject activity = QJniObject::callStaticObjectMethod("org/qtproject/qt/android/QtNative",
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

    jfieldID fIDDensityDpi = env->GetFieldID(displayMetricsClass, "density", "F");
    jfloat densityDpi = env->GetFloatField(displayMetrics, fIDDensityDpi);

    float result = (float)densityDpi;

    env->PopLocalFrame(NULL);

    return result;
#else
    return QGuiApplication::primaryScreen()->physicalDotsPerInch();
#endif
}

int ScreenValues::getResourceSize(const QString &resource)
{
#ifdef Q_OS_ANDROID
    QJniObject activity = QJniObject::callStaticObjectMethod("org/qtproject/qt/android/QtNative",
                                                                           "activity",
                                                                           "()Landroid/app/Activity;");

    QJniObject resources = activity.callObjectMethod("getResources", "()Landroid/content/res/Resources;");

    QJniObject jName = QJniObject::fromString(resource);
    QJniObject jDefType = QJniObject::fromString("dimen");
    QJniObject jDefPackage = QJniObject::fromString("android");

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
