TEMPLATE = app

TARGET = qute-launcher

QT += qml quick widgets svg network

android {
    QT += androidextras

    OTHER_FILES += \
        android/src/com/iktwo/qutelauncher/*.java \
        android/src/org/qtproject/qt5/android/bindings/*.java \
        android/res/values-v21/* \
        android/res/values-v19/* \
        android/res/values/* \
        android/AndroidManifest.xml
}

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

HEADERS += $$files($$PWD/src/*.h)

SOURCES += $$files($$PWD/src/*.cpp)

RESOURCES += resources.qrc

include(deployment.pri)

