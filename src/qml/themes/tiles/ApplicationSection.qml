import QtQuick 2.2
import "."

Item {
    id: root

    property alias text: textElement.text

    signal clicked()

    width: height
    height: delegateHeight

    Rectangle {
        anchors {
            left: parent.left
            leftMargin: 20
            verticalCenter: parent.verticalCenter
        }

        border.color: Configuration.color
        border.width: parent.height * 0.01
        color: "transparent"
        width: parent.height * 0.8
        height: width

        Text {
            id: textElement

            anchors.centerIn: parent
            color: Configuration.color
            font {
                pointSize: 24
                bold: true
            }
        }
    }

    MouseArea {
        anchors.fill: parent

        onClicked: root.clicked()
    }
}
