import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import com.iktwo.qutelauncher 1.0 as QL
import config 1.0 as Config
import debug 1.0 as D

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

    property bool activeScreen: Qt.application.state === Qt.ApplicationActive

    function updatePortraitMode() {
        if (height >= width)
            Config.Theme.portrait = true
        else
            Config.Theme.portrait = true
    }

    function getScreenDensityConfiguration(density) {
        switch(density) {
        case 420:
            return "xxhigh"
        case 480:
            return "xxhigh"
        case 560:
            return "xxxhigh"
        case 640:
            return "xxxhigh"
        }
    }

    color: Config.Theme.colorApplicationWindow

    width: resolutions[currentResolution].width
    height: resolutions[currentResolution].height

    visible: true

    onWidthChanged: updatePortraitMode()
    onHeightChanged: updatePortraitMode()

    onActiveScreenChanged: {
        if (activeScreen)
            QL.ScreenValues.updateScreenValues()
    }

    Component.onCompleted: {
        Config.Theme.tablet = QL.ScreenValues.isTablet
    }

    FocusScope {
        id: keyHandler

        height: 1
        width: 1

        focus: true

        Keys.onBackPressed: {
            if (loaderMainTheme.item && loaderMainTheme.item.opened) {
                QL.Launcher.minimize()
            }
        }

        Keys.onUpPressed: {
            if (Qt.platform.os !== "android")
                explandableItem.open()

            event.accepted = false
        }

        Keys.onDownPressed: {
            if (Qt.platform.os !== "android")
                explandableItem.close()

            event.accepted = false
        }
    }

    Timer {
        interval: 550
        running: true

        onTriggered: {
            QL.Launcher.registerMethods()
            QL.PackageManager.registerBroadcast()
        }
    }

    Loader {
        id: loader

        function unload() {
            sourceComponent = null
        }

        anchors.fill: parent

        /// TODO: load only if this has never been displayed
        // sourceComponent: introView

        Component {
            id: introView

            IntroView {
                anchors.fill: parent

                statusbarMargin: QL.ScreenValues.statusBarHeight
                navbarMargin: QL.ScreenValues.navBarVisible ? QL.ScreenValues.navigationBarHeight : 0

                //        enabled: false
                //        visible: false

                model: ListModel {
                    ListElement { name: "IntroMain.qml"; backgroundColor: "#424242" }
                    ListElement { name: "IntroEnd.qml"; backgroundColor: "#2c3e50" }
                }

                onDone: loader.unload()
            }
        }

    }

    Image  {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: QL.ScreenValues.statusBarHeight

        fillMode: Image.Tile

        source: "qrc:/images/shadow"
    }

    Image  {
        id: borderImageNavBar

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: QL.ScreenValues.navBarVisible ? QL.ScreenValues.navigationBarHeight : 0

        fillMode: Image.Tile

        source: QL.ScreenValues.navBarVisible ? "qrc:/images/shadow_navigationbar" : ""
    }

    Loader {
        id: loaderMainTheme

        anchors.fill: parent
        source: "themes/classic/ThemeMain.qml"
    }

    //    D.Debug {
    //        debugData: {
    //            'sdkInt': QL.System.sdkInt,
    //                    'height': applicationWindow.height,
    //                    'width': applicationWindow.width,
    //                    'dp': QL.ScreenValues.dp.toFixed(2),
    //                    'dpi': QL.ScreenValues.dpi.toFixed(2),
    //                    'density': QL.ScreenValues.density.toFixed(2),
    //                    'isTablet': QL.ScreenValues.isTablet,
    //                    'navBarVisible': QL.ScreenValues.navBarVisible
    //        }
    //    }
}
