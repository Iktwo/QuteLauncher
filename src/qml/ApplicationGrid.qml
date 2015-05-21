import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0
import com.iktwo.qutelauncher 1.0

GridView {
    id: root

    property int highlightedItem

    maximumFlickVelocity: height * 2.5

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

    cellHeight: height / 6
    cellWidth: width / 4

    delegate: Item {
        id: itemDelegate

        height: GridView.view.cellHeight
        width: GridView.view.cellWidth

        ColumnLayout {
            id: container

            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }

            Image {
                id: icon

                anchors.horizontalCenter: parent.horizontalCenter

                Layout.preferredHeight: Math.round(59 * ScreenValues.dp)
                Layout.preferredWidth: Math.round(59 * ScreenValues.dp)

                // antialiasing: true
                asynchronous: true
                fillMode: Image.PreserveAspectFit
                source: "image://icon/" + model.packageName
            }

            Label {
                anchors.horizontalCenter: parent.horizontalCenter

                Layout.preferredWidth: parent.width * 0.90

                text: model.name

                elide: Text.ElideRight
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.NoWrap
                maximumLineCount: 1

                font.pixelSize: 12 * ScreenValues.dp

                color: "#666666"
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: PackageManager.launchApplication(model.packageName)
        }
    }

    onHeightChanged: {
        if (cacheBuffer !== 0)
            cacheBuffer = Math.max(1080, height * 5)
    }
}
