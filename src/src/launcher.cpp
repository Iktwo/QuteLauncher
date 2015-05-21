#include "launcher.h"

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#endif

Launcher::Launcher(QObject *parent) : QObject(parent)
{

}

void Launcher::pickWallpaper()
{
#ifdef Q_OS_ANDROID
    QAndroidJniObject::callStaticMethod<void>("com/iktwo/qutelauncher/QuteLauncher",
                                              "pickWallpaper",
                                              "()V");
#endif
}
