#ifndef ICONIMAGEPROVIDER_H
#define ICONIMAGEPROVIDER_H

#include <QQuickImageProvider>

class IconImageProvider : public QQuickImageProvider
{
public:
    explicit IconImageProvider();

    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize);
};

#endif // ICONIMAGEPROVIDER_H
