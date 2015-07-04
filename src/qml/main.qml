import QtQuick 2.5
import QtQuick.Controls 1.4
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

    onActiveScreenChanged: {
        if (activeScreen)
            ScreenValues.updateScreenValues()
    }

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

    BorderImage  {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: ScreenValues.statusBarHeight

        source: "qrc:/images/shadow"
        border.left: 5; border.top: 5
        border.right: 5; border.bottom: 5
    }

    BorderImage  {
        id: borderImageNavBar

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: ScreenValues.navBarVisible ? ScreenValues.navigationBarHeight : 0
        source: ScreenValues.navBarVisible ? "qrc:/images/shadow_navigationbar" : ""

        border {
            left: 5; top: 5
            right: 5; bottom: 5
        }
    }

    Item {
        anchors {
            top: parent.top; topMargin: ScreenValues.statusBarHeight
            /// TODO: ask orientation and ask if nav bar is actually visible
            /// it might not be in devices with hardware controls
            bottom: borderImageNavBar.top
            left: parent.left
            right: parent.right

        }

        ExpandableItem {
            id: explandableItem

            anchors.fill: parent

            ApplicationGrid {
                model: PackageManager

                anchors.fill: parent
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        enabled: explandableItem.busy
    }
}
