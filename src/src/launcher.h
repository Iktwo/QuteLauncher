#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#endif

class Launcher : public QObject
{
    Q_OBJECT
public:
    explicit Launcher(QObject *parent = 0);

    Q_INVOKABLE void pickWallpaper();
    Q_INVOKABLE void emitNewIntent();
    Q_INVOKABLE void registerMethods();

signals:
    void newIntentReceived();

private:
    void registerNativeMethods();

#ifdef Q_OS_ANDROID
    QAndroidJniObject mActivity;
#endif
};

#endif // LAUNCHER_H
