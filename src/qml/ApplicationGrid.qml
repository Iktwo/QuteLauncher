import QtQuick 2.4
import QtQuick.Controls 1.3
import QtGraphicalEffects 1.0

GridView {
    id: root

    property int highlightedItem

    maximumFlickVelocity: height * 2.5
    cacheBuffer: height * 5

    add: Transition {
        NumberAnimation { properties: "opacity"; from: 0; to: 1; duration: 450 }
        NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 500 }
    }

    displaced: Transition {
        NumberAnimation { property: "opacity"; to: 1.0 }
        NumberAnimation { property: "scale"; to: 1.0 }
    }

    visible: false
    interactive: visible

    cellHeight: height / 5
    cellWidth: width / 4

    delegate: Item {
        id: itemDelegate

        property var rect: mapToItem(root.parent)

        height: GridView.view.cellHeight
        width: GridView.view.cellWidth

        onXChanged: rect = mapToItem(root.parent)
        onYChanged: rect = mapToItem(root.parent)
        onHeightChanged: rect = mapToItem(root.parent)
        onWidthChanged: rect = mapToItem(root.parent)

        Item {
            id: container

            anchors {
                fill: parent
                margins: dpi * 0.04
            }

            Label {
                anchors {
                    left: parent.left; leftMargin: dpi * 0.02
                    right: parent.right; rightMargin: dpi * 0.02
                    bottom: parent.bottom; bottomMargin: dpi * 0.03
                }

                text: model.name

                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.NoWrap
                maximumLineCount: 2

                font {
                    pointSize: 14
                }

                color: "white"
            }

            Image {
                id: icon

                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top; topMargin: parent.height * 0.2
                }

                antialiasing: true
                height: parent.height * 0.6
                width: parent.width * 0.6
                asynchronous: true
                fillMode: Image.PreserveAspectFit
                source: "image://icon/" + model.packageName
            }

        }

        MouseArea {
            anchors.fill: parent
            onClicked: packageManager.launchApplication(model.packageName)
        }
    }
}
