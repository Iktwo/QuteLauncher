#include <QApplication>
#include <QQuickView>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QSettings>
#include <QThread>
#include <QDebug>

#include "packagemanager.h"
#include "iconimageprovider.h"
#include "wallpaperprovider.h"
#include "uivalues.h"

int main(int argc, char *argv[])
{
    QScopedPointer<QApplication> app(new QApplication(argc, argv));

    QCoreApplication::setOrganizationName("Iktwo Corp.");
    QCoreApplication::setOrganizationDomain("iktwo.com");
    QCoreApplication::setApplicationName("QuteLauncher");

    QQmlApplicationEngine engine;

    qDebug() << "PATH: " << QCoreApplication::applicationDirPath();

    QObject::connect(&engine, SIGNAL(quit()), QCoreApplication::instance(), SLOT(quit()));

    PackageManager pm;

    engine.rootContext()->setContextProperty("packageManager", &pm);
    engine.addImageProvider(QLatin1String("icon"), new IconImageProvider());
    engine.addImageProvider(QLatin1String("wallpaper"), new WallpaperProvider());

    UIValues uiValues;
    engine.rootContext()->setContextProperty(QStringLiteral("uiValues"), &uiValues);

    engine.load(QUrl("qrc:/qml/qml/main.qml"));

    return app->exec();
}
