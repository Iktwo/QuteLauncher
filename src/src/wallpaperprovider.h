#ifndef WALLPAPERPROVIDER_H
#define WALLPAPERPROVIDER_H

#include <QQuickImageProvider>

class WallpaperProvider : public QQuickImageProvider
{
public:
    explicit WallpaperProvider();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);
};

#endif // WALLPAPERPROVIDER_H
