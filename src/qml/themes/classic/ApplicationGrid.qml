import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import com.iktwo.qutelauncher 1.0 as QL
import config 1.0 as Config

ScrollView {
    id: root

    property alias model: gridView.model

    signal pressAndHold(var model, int x, int y)

    anchors.fill: parent

    style: ScrollViewStyle {
        transientScrollBars: false

        scrollBarBackground: Rectangle {
            implicitWidth: 5 * QL.ScreenValues.dp

            color: "#d9d9d9"
        }

        handle: Rectangle {
            implicitWidth: 5 * QL.ScreenValues.dp

            color: "#129688"
        }

        corner: Item { }
        decrementControl: Item { }
        incrementControl: Item { }
    }

    flickableItem.focus: true
    flickableItem.interactive: true

    GridView {
        id: gridView

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
}
