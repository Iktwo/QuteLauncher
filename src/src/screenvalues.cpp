#include "screenvalues.h"

#include <QScreen>
#include <QGuiApplication>

#ifdef Q_OS_ANDROID
#include <QAndroidJniEnvironment>
#include <QAndroidJniObject>
#endif

ScreenValues::ScreenValues(QObject *parent) :
    QObject(parent),
    m_dpi(0),
    m_isTablet(false)
{
    m_dpi = retrieveDpi();

    m_dp = (float) m_dpi / 160;
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
