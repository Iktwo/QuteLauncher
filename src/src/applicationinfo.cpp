#include "applicationinfo.h"

#include <QSettings>
#include <QDebug>

#ifdef Q_OS_ANDROID
#include <QJniEnvironment>
#include <QJniObject>
#endif

ApplicationInfo::ApplicationInfo(QObject *parent) :
    QObject(parent),
    m_timesLaunched(0),
    m_hasShownInitialDialog(false)
{
    QSettings settings;
    m_timesLaunched = settings.value("timesLaunched", 0).toInt();
    m_hasShownInitialDialog = settings.value("hasShownInitialDialog", false).toBool();

    m_firstTimeLaunched = settings.value("firstTimeLaunched", QDate::fromString("20000101", "yyyyMMdd")).toDate();

    if (m_firstTimeLaunched.toString("yyyyMMdd") == "20000101")
        setFirstTimeLaunched(QDate::currentDate());

    m_OSVersion = getOSVersion();
    setTimesLaunched(m_timesLaunched + 1);
}

int ApplicationInfo::timesLaunched() const
{
    return m_timesLaunched;
}

void ApplicationInfo::setTimesLaunched(int timesLaunched)
{
    if (m_timesLaunched == timesLaunched)
        return;

    m_timesLaunched = timesLaunched;

    QSettings settings;
    settings.setValue("timesLaunched", m_timesLaunched);

    emit timesLaunchedChanged();
}

QDate ApplicationInfo::firstTimeLaunched() const
{
    return m_firstTimeLaunched;
}

void ApplicationInfo::setFirstTimeLaunched(const QDate &firstTimeLaunched)
{
    if (m_firstTimeLaunched == firstTimeLaunched)
        return;

    m_firstTimeLaunched = firstTimeLaunched;

    QSettings settings;
    settings.setValue("firstTimeLaunched", m_firstTimeLaunched);

    emit firstTimeLaunchedChanged();
}

bool ApplicationInfo::hasShownInitialDialog() const
{
    return m_hasShownInitialDialog;
}

void ApplicationInfo::setHasShownInitialDialog(bool hasShownInitialDialog)
{
    if (m_hasShownInitialDialog == hasShownInitialDialog)
        return;

    m_hasShownInitialDialog = hasShownInitialDialog;

    QSettings settings;
    settings.setValue("hasShownInitialDialog", m_hasShownInitialDialog);

    emit hasShownInitialDialogChanged();
}

int ApplicationInfo::OSVersion() const
{
    return m_OSVersion;
}

void ApplicationInfo::setOSVersion(int version)
{
    if (m_OSVersion == version)
        return;

    m_OSVersion = version;
    emit OSVersionChanged();
}

int ApplicationInfo::getOSVersion()
{
#ifdef Q_OS_ANDROID
    jint version = QJniObject::getStaticField<jint>("android.os.Build$VERSION", "SDK_INT");
    return version;
#else
    return -1;
#endif
}

