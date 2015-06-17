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
    property bool activeScreen: Qt.application.state === Qt.ApplicationActive

    color: "#00000000"

    width: resolutions[currentResolution].width
    height: resolutions[currentResolution].height

    visible: true

    onActiveScreenChanged: console.log("activeScreen", activeScreen)

    FocusScope {
        id: backKeyHandler
        height: 1
        width: 1

        focus: true

        Keys.onAsteriskPressed: {
            if (explandableItem.isOpened) {
                explandableItem.close()
            }
        }

        Keys.onBackPressed: {
            if (explandableItem.isOpened) {
                explandableItem.close()
            }
        }
    }

    Timer {
        interval: 550
        running: true
        onTriggered: PackageManager.registerBroadcast()
    }

    Label {
        anchors.centerIn: parent

        color: "#cccccc"

        font {
            weight: Font.Light
            pixelSize: ScreenValues.dp * 56
        }

        width: parent.width
        wrapMode: Text.Wrap
        horizontalAlignment: Text.AlignHCenter

        Timer {
            interval: 1000 * 60
            running: true

            triggeredOnStart: true
            onTriggered: {
                var date = new Date()
                parent.text = date.toLocaleTimeString(Qt.locale().name)
                interval = (1000 * (60 - date.getSeconds()))
                restart()
            }
        }
    }

    ExpandableItem {
        id: explandableItem

        anchors.fill: parent

        ApplicationGrid {
            model: PackageManager

            anchors.fill: parent
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: explandableItem.busy
    }
}
