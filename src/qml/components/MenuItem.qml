import QtQuick
import QtQuick.Controls

Item {
    id: root

    property alias text: textElement.text

    signal clicked()

    width: parent.width
    height: applicationWindow.height / 7

    Label {
        id: textElement

        anchors {
            fill: parent
            leftMargin: root.width * 0.02
            rightMargin: root.width * 0.02
            topMargin: root.height * 0.06
            bottomMargin: root.height * 0.06
        }

        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight

        font {
            pointSize: 22
        }

        transform: Rotation { origin.x: 0; origin.y: textElement.height / 2; axis { x: 0; y: 1; z: 0 } angle: mouseArea.pressed ? -10 : 0 }

        scale: mouseArea.pressed ? 0.98 : 1
        color: root.enabled ? "black" : "#8d8d8d"
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent

        enabled: root.enabled

        onClicked: {
            root.clicked()

            try {
                root.parent.close()
            } catch (e) {
                console.log("MenuItem is meant to be used inside a PressAndHoldMenu")
            }
        }
    }
}
