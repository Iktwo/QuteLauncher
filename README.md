# Qute Launcher

![](http://iktwo.github.io/QuteLauncher/images/icon.png)

Qute Launcher is and Android Launcher written with Qt, it is in alpha state but it already supports launching applications.

Requires Qt >= 5.5

# Screenshot
![](http://iktwo.github.io/QuteLauncher/images/screenshot.jpg)

# Features
* Application icon retrieval.
* Detect app installation or removal.

# TODO
* Add wallpaper picker.
* Add support for themes.
* Add intro screen to configure theme.
* Add home screens and favorites bar.
* Support icon themes.
* Investigate if it is possible to integrate widgets.

# Analytics

This project uses Firebase Analytics to collect usage data.

# How to compile

In order to build this project you need to use Gradle. There are no Qt/QML dependencies. If you have Qt >= 5.5 for Android open the project with QtCreator or follow this instructions if you don't want to use QtCreator http://doc.qt.io/qt-5/deployment-android.html passing --gradle to the androiddeployqt tool.
