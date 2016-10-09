import QtQuick 2.0
import com.iktwo.qutelauncher 1.0 as QL
import config 1.0 as Config

FocusScope {
    id: root

    property int navbarMargin: QL.ScreenValues.navBarVisible ? QL.ScreenValues.navigationBarHeight : 0
    property int statusbarMargin: QL.ScreenValues.statusBarHeight

    property bool opened: explandableItem.isOpened

    focus: true

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

    MouseArea {
        anchors.fill: parent

        enabled: !explandableItem.isOpened

        onPressAndHold: QL.Launcher.pickWallpaper()
    }

    GridView {
        id: gridView

        anchors.fill: parent

        property int highlightedItem

        maximumFlickVelocity: height * 5

        header: Item {
            width: parent.width
            height: 20 * QL.ScreenValues.dp
        }

        add: Transition {
            NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 450 }
            NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 500 }
        }

        displaced: Transition {
            NumberAnimation { property: "opacity"; to: 1.0 }
            NumberAnimation { property: "scale"; to: 1.0 }
        }

        clip: true
        interactive: visible

        cellHeight: height / Config.Theme.getColumns()
        cellWidth: width / Config.Theme.getRows()

        model: listModelFavorites

        delegate: ApplicationTile {
            id: applicationTile

            height: GridView.view.cellHeight
            width: GridView.view.cellWidth

            source: "image://icon/" + model.packageName
            text: model.name

            onClicked: QL.PackageManager.launchApplication(model.packageName)
            onPressAndHold: root.pressAndHold(model, x, y)
        }

        onHeightChanged: {
            if (height !== 0)
                cacheBuffer = Math.max(1080, height * 5)
        }
    }

    Item {
        anchors {
            top: parent.top; topMargin: QL.ScreenValues.statusBarHeight
            bottom: parent.bottom; bottomMargin: root.navbarMargin
            left: parent.left
            right: parent.right
        }

        ExpandableItem {
            id: explandableItem

            anchors.fill: parent

            ApplicationGrid {
                model: QL.PackageManager

                anchors.fill: parent

                onPressAndHold: {
                    /// TODO: implement this
                    // applicationTile.source = "image://icon/" + model.packageName
                    // applicationTile.text = model.name
                    applicationGridMenu.packageName = model.packageName
                    applicationGridMenu.name = model.name
                    applicationGridMenu.open(x, y)
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        enabled: explandableItem.busy
    }

    GridView {
        /// TODO: verify in landscape mode
        anchors {
            top: parent.top; topMargin: QL.ScreenValues.statusBarHeight
            left: parent.left
            right: parent.right
        }

        height: 4 * (80 * QL.ScreenValues.dp)
        model: 16
        enabled: false
        interactive: false
        cellHeight: height / 4
        cellWidth: width / 4

        delegate: DropArea {
            width: GridView.view.cellWidth
            height: GridView.view.cellHeight
        }
    }

    Row {
        id: rowFavorites

        anchors {
            bottom: parent.bottom; bottomMargin: root.navbarMargin
        }

        height: 80 * QL.ScreenValues.dp

        Repeater {
            model: 5

            DropArea {
                width: 80 * QL.ScreenValues.dp
                height: 80 * QL.ScreenValues.dp
            }
        }
    }

    Connections {
        target: QL.Launcher

        onNewIntentReceived: explandableItem.close()
        onMinimized: explandableItem.close()
    }

    ApplicationGridMenu {
        id: applicationGridMenu

        screenHeight: root.height

        onClosed: explandableItem.close()
    }
}
