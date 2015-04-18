#include "wallpaperprovider.h"

#ifdef Q_OS_ANDROID
#include <QAndroidJniObject>
#include <QAndroidJniEnvironment>
#endif

#include <QDebug>

WallpaperProvider::WallpaperProvider() :
    QQuickImageProvider(QQuickImageProvider::Image)
{
}

QImage WallpaperProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(size);
    Q_UNUSED(requestedSize);
    Q_UNUSED(id);
    QImage image;

#ifdef Q_OS_ANDROID
    QAndroidJniObject applicationIcon = QAndroidJniObject::callStaticObjectMethod("com/iktwo/qutelauncher/QuteLauncher",
                                                                                  "getSystemWallpaper",
                                                                                  "()[B");

    QAndroidJniEnvironment env;
    jbyteArray iconDataArray = applicationIcon.object<jbyteArray>();
    if (!iconDataArray)
        return image;

    jsize iconSize = env->GetArrayLength(iconDataArray);

    if (iconSize > 0) {
        jbyte *icon = env->GetByteArrayElements(iconDataArray, false);
        image = QImage::fromData((uchar*) icon, iconSize,"PNG");
        env->ReleaseByteArrayElements(iconDataArray, icon, JNI_ABORT);
    }
#else
    return QImage("://images/background","JPG");
#endif

    return image;
}
