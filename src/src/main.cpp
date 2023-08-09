#include <QGuiApplication>
#include <QQuickView>
#include <QQmlApplicationEngine>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQmlContext>
#include <QSettings>
#include <QThread>
#include <QDebug>

#include "applicationinfo.h"
#include "iconimageprovider.h"
#include "launcher.h"
#include "packagemanager.h"
#include "screenvalues.h"
#include "system.h"

static QObject *package_manager_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new PackageManager();
}

static QObject *screen_values_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new ScreenValues();
}

static QObject *launcher_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new Launcher();
}

static QObject *system_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new System();
}

static QObject *application_info_provider(QQmlEngine *engine, QJSEngine *scriptEngine)
{
    Q_UNUSED(engine)
    Q_UNUSED(scriptEngine)

    return new ApplicationInfo();
}

int main(int argc, char *argv[])
{
    QScopedPointer<QGuiApplication> app(new QGuiApplication(argc, argv));

    QCoreApplication::setOrganizationName("Iktwo Corp.");
    QCoreApplication::setOrganizationDomain("iktwo.com");
    QCoreApplication::setApplicationName("QuteLauncher");

    QQmlApplicationEngine engine;

    QObject::connect(&engine, SIGNAL(quit()), QGuiApplication::instance(), SLOT(quit()));

    qmlRegisterSingletonType<PackageManager>("com.iktwo.qutelauncher", 1, 0, "PackageManager", package_manager_provider);
    qmlRegisterSingletonType<ApplicationInfo>("com.iktwo.qutelauncher", 1, 0, "ApplicationInfo", application_info_provider);
    qmlRegisterSingletonType<ScreenValues>("com.iktwo.qutelauncher", 1, 0, "ScreenValues", screen_values_provider);
    qmlRegisterSingletonType<System>("com.iktwo.qutelauncher", 1, 0, "System", system_provider);
    qmlRegisterSingletonType<Launcher>("com.iktwo.qutelauncher", 1, 0, "Launcher", launcher_provider);

    engine.addImageProvider(QLatin1String("icon"), new IconImageProvider());
    engine.addImportPath("qrc:/qml/qml");

    engine.load(QUrl("qrc:/qml/qml/main.qml"));

    return app->exec();
}
