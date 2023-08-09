#include "iconimageprovider.h"

#ifdef Q_OS_ANDROID
#include <QJniObject>
#include <QJniEnvironment>
#endif

#include <QDebug>

IconImageProvider::IconImageProvider() :
    QQuickImageProvider(QQuickImageProvider::Image)
{
}

QImage IconImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(size);
    Q_UNUSED(requestedSize);
    QImage image;

#ifdef Q_OS_ANDROID
    QJniObject appIcon = QJniObject::callStaticObjectMethod("com/iktwo/qutelauncher/QuteLauncher",
                                                                          "getApplicationIcon",
                                                                          "(Ljava/lang/String;)[B",
                                                                          QJniObject::fromString(id).object<jstring>());

    QJniEnvironment env;
    jbyteArray iconDataArray = appIcon.object<jbyteArray>();

    if (!iconDataArray) {
        qDebug() << Q_FUNC_INFO << "No icon data";

        return image;
    }

    jsize iconSize = env->GetArrayLength(iconDataArray);

    if (iconSize > 0) {
        jboolean jfalse = false;
        jbyte *icon = env->GetByteArrayElements(iconDataArray, &jfalse);
        image = QImage::fromData((uchar*) icon, iconSize,"PNG");
        env->ReleaseByteArrayElements(iconDataArray, icon, JNI_ABORT);
    }

    return image;
#else
    Q_UNUSED(id)
    return QImage("://images/test","PNG");
#endif

}
