import QtQuick 2.0
import com.iktwo.qutelauncher 1.0 as QL

Item {
    id: root

    property int navbarMargin: QL.ScreenValues.navBarVisible ? QL.ScreenValues.navigationBarHeight : 0
    property int statusbarMargin: QL.ScreenValues.statusBarHeight

    property bool opened: explandableItem.isOpened

    MouseArea {
        anchors.fill: parent

        enabled: !explandableItem.isOpened

        onPressAndHold: QL.Launcher.pickWallpaper()
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

                    explandableItem.close()
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
}
