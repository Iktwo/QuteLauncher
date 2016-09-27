#ifndef APPLICATIONINFO_H
#define APPLICATIONINFO_H

#include <QObject>
#include <QDate>

class ApplicationInfo : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int timesLaunched READ timesLaunched NOTIFY timesLaunchedChanged)
    Q_PROPERTY(QDate firstTimeLaunched READ firstTimeLaunched NOTIFY firstTimeLaunchedChanged)
    Q_PROPERTY(bool hasShownInitialDialog READ hasShownInitialDialog WRITE setHasShownInitialDialog NOTIFY hasShownInitialDialogChanged)
    Q_PROPERTY(int OSVersion READ OSVersion WRITE setOSVersion NOTIFY OSVersionChanged)

public:
    ApplicationInfo(QObject *parent = 0);

    int timesLaunched() const;
    void setTimesLaunched(int timesLaunched);

    QDate firstTimeLaunched() const;
    void setFirstTimeLaunched(const QDate &firstTimeLaunched);

    bool hasShownInitialDialog() const;
    void setHasShownInitialDialog(bool hasShownInitialDialog);

    int OSVersion() const;
    void setOSVersion(int version);

signals:
    void timesLaunchedChanged();
    void firstTimeLaunchedChanged();
    void hasShownInitialDialogChanged();
    void OSVersionChanged();

private:
    int m_timesLaunched;
    QDate m_firstTimeLaunched;
    bool m_hasShownInitialDialog;
    int m_OSVersion;

    int getOSVersion();

};

#endif // APPLICATIONINFO_H
