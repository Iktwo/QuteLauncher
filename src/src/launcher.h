#ifndef LAUNCHER_H
#define LAUNCHER_H

#include <QObject>

class Launcher : public QObject
{
    Q_OBJECT
public:
    explicit Launcher(QObject *parent = 0);

    Q_INVOKABLE void pickWallpaper();

};

#endif // LAUNCHER_H
