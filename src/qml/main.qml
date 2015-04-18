import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import com.iktwo.qutelauncher 1.0

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
        color: "#000000"
    }

    Image {
        id: imageBackground

        anchors.fill: parent

        fillMode: Image.PreserveAspectCrop

        asynchronous: true
        antialiasing: true

        source: "image://wallpaper/"
    }

    Rectangle {
        anchors {
            fill: parent
            leftMargin: 8 * ScreenValues.dp
            rightMargin: 8 * ScreenValues.dp
            topMargin: 6 * ScreenValues.dp
            bottomMargin: 38 * ScreenValues.dp
        }

        color: "#f5f5f5"
        radius: 2 * ScreenValues.dp

        ApplicationGrid {
            id: applicationGrid

            visible: true
            model: PackageManager

            anchors.fill: parent
        }
    }

    BusyIndicator {
        anchors.centerIn: parent
        running: imageBackground.status !== Image.Error && imageBackground.status !== Image.Ready
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
        onTriggered: PackageManager.registerBroadcast()
    }
}
