#ifndef PACKAGEMANAGER_H
#define PACKAGEMANAGER_H

#include <QAbstractListModel>

#ifdef Q_OS_ANDROID
#include <QJniObject>
#endif

class PackageManager : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(QStringList sections READ sections NOTIFY sectionsChanged)

public:
    explicit PackageManager(QObject *parent = 0);

    enum Roles {
        NameRole = Qt::UserRole +1,
        PackageNameRole,
        CategoryRole
    };

    int rowCount(const QModelIndex &parent) const;

    QVariant data(const QModelIndex &index, int role) const;

    Q_INVOKABLE void launchApplication(const QString &application);
    Q_INVOKABLE void registerBroadcast();
    Q_INVOKABLE int indexOfSection(const QString &section);
    Q_INVOKABLE void openApplicationInfo(const QString &packageName);
    Q_INVOKABLE void addApplicationToGrid(const QString &name, const QString &packageName);

    Q_INVOKABLE void testJNICall();

#ifdef Q_OS_ANDROID
    static QString jstringToQString(jstring string);
#endif

    Q_INVOKABLE void emitAddApplication(const QString &name, const QString &packageName);
    Q_INVOKABLE void emitRemoveApplication(const QString &packageName);

    QStringList sections() const;

public slots:
    void retrievePackages();
    void addApplication(const QString &name, const QString &packageName);
    void removeApplication(const QString &packageName);

protected:
    QHash<int, QByteArray> roleNames() const;

signals:
    void newApplicationDetected(const QString &name, const QString &packageName);
    void addedApplicationToGrid(const QString &name, const QString &packageName);
    void removedApplication(const QString &packageName);
    void sectionsChanged();

private:
    QObjectList mApplications;
    QMap<QString, QObject> mApps;
    QStringList mSections;
    QList<int> mSectionsPositions;

    void registerNativeMethods();
    //void sortApplications();

#ifdef Q_OS_ANDROID
    QJniObject mAndroidActivity;
    QJniObject mIntentFilter;
    QJniObject mBroadcastReceiver;
#endif
};

#endif // PACKAGEMANAGER_H
