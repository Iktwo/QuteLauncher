#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>

#ifdef Q_OS_ANDROID
#include <QJniObject>
#endif

class Launcher : public QObject
{
    Q_OBJECT
public:
    explicit Launcher(QObject *parent = 0);

    Q_INVOKABLE void pickWallpaper();
    Q_INVOKABLE void emitNewIntent();
    Q_INVOKABLE void registerMethods();
    Q_INVOKABLE void minimize();

signals:
    void newIntentReceived();
    void minimized();

private:
    void registerNativeMethods();

#ifdef Q_OS_ANDROID
    QJniObject mActivity;
#endif
};

#endif // LAUNCHER_H
