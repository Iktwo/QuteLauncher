TEMPLATE = app

TARGET = qute-launcher

QT += qml quick widgets svg network

android {
    QT += androidextras gui-private

    OTHER_FILES += \
        android/src/com/iktwo/qutelauncher/QPackageManager.java \
        android/src/com/iktwo/qutelauncher/PackageChangedReceiver.java \
        android/AndroidManifest.xml
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

HEADERS += $$files($$PWD/src/*.h)

SOURCES += $$files($$PWD/src/*.cpp)

RESOURCES += resources.qrc

include(deployment.pri)
