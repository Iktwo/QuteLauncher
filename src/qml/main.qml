import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2

ApplicationWindow {
    id: applicationWindow

    property bool isWindowActive: Qt.application.state === Qt.ApplicationActive
    property int dpi: Screen.pixelDensity * 25.4

    property var resolutions: [
        {"height": 480, "width": 320}, // HVGA
        {"height": 640, "width": 480}, // VGA
        {"height": 800, "width": 480}, // WVGA
        {"height": 800, "width": 600}, // SVGA
        {"height": 640, "width": 360}, // nHD
        {"height": 960, "width": 540}  // qHD
    ]

    property int currentResolution: 3
    property bool isScreenPortrait: height >= width

    width: 480
    height: 800
    visible: true

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Image {
        id: imageBackground

        anchors.fill: parent
        opacity: 0.5

        fillMode: Image.PreserveAspectCrop

        asynchronous: true
        antialiasing: true

        source: "image://wallpaper/"
    }

    ApplicationGrid {
        id: applicationGrid

        visible: true
        model: packageManager

        anchors.fill: parent
    }

    FocusScope {
        id: backKeyHandler
        height: 1
        width: 1

        focus: true
        Keys.onBackPressed: { }
    }

    Timer {
        interval: 550
        running: true
        onTriggered: packageManager.registerBroadcast()
    }
}
