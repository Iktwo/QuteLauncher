import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.2
import Qt.labs.settings 1.0
import com.iktwo.qutelauncher 1.0 as QL
import config 1.0 as Config
import debug 1.0 as D

ApplicationWindow {
    id: applicationWindow

    property bool isWindowActive: Qt.application.state === Qt.ApplicationActive
    property int dpi: Screen.pixelDensity * 25.4

    property variant favoritesData: ([])

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

    onFavoritesDataChanged: {
        listModelFavorites.clear()

        for (var i = 0; i < favoritesData.length; ++i) {
            listModelFavorites.append(favoritesData)
        }
    }

    Component.onCompleted: {
        Config.Theme.tablet = QL.ScreenValues.isTablet
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
        id: loaderMainTheme

        anchors.fill: parent

        source: "themes/" + Config.Theme.theme + "/ThemeMain.qml"

        Keys.onBackPressed: {
            event.accepted = true

            if (loaderMainTheme.item && loaderMainTheme.item.opened) {
                QL.Launcher.minimize()
            }
        }

        Keys.onEscapePressed: {
            if (loaderMainTheme.item && loaderMainTheme.item.opened) {
                QL.Launcher.minimize()
            }
        }

    }

    Loader {
        id: loader

        function unload() {
            sourceComponent = null
            loaderMainTheme.focus = true
        }

        anchors.fill: parent

        sourceComponent: !QL.ApplicationInfo.hasShownInitialDialog ? introView : undefined

        focus: true

        // TODO: Remove this once the intro is ready
        Component.onCompleted: {
            unload()
        }

        Component {
            id: introView

            IntroView {
                anchors.fill: parent

                statusbarMargin: QL.ScreenValues.statusBarHeight
                navbarMargin: QL.ScreenValues.navBarVisible ? QL.ScreenValues.navigationBarHeight : 0

                model: ListModel {
                    ListElement { name: "IntroMain.qml"; backgroundColor: "#424242" }
                    ListElement { name: "IntroSelection.qml"; backgroundColor: "#2c3e50" }
                    ListElement { name: "IntroEnd.qml"; backgroundColor: "#424242" }
                }

                onDone: {
                    QL.ApplicationInfo.hasShownInitialDialog = true
                    loader.unload()
                }
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

    Connections {
        target: QL.PackageManager

        onAddedApplicationToGrid: {
            var favs = favoritesData
            favs.push({'name': name, 'packageName': packageName})
            favoritesData = favs
        }
    }

    Settings {
        property alias favorites: applicationWindow.favoritesData
    }

    ListModel {
        id: listModelFavorites
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
