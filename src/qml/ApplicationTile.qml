import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2
import com.iktwo.qutelauncher 1.0

Item {
    id: root

    property alias text: label.text
    property alias source: image.source
    property var dragTarget

    property var _originalParent
    property var _newParent

    signal pressAndHold(var model)
    signal clicked

    Drag.active: mouseArea.drag.active
    Drag.hotSpot.x: width / 2
    Drag.hotSpot.y: height / 2

    width: 80
    height: 80

    Component.onCompleted: {
        _originalParent = parent
        _newParent = _originalParent
    }

    ColumnLayout {
        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        Image {
            id: image

            anchors.horizontalCenter: parent.horizontalCenter

            asynchronous: true

            Layout.preferredHeight: Math.round(59 * ScreenValues.dp)
            Layout.preferredWidth: Math.round(59 * ScreenValues.dp)

            fillMode: Image.PreserveAspectFit
        }

        Label {
            id: label

            anchors.horizontalCenter: parent.horizontalCenter

            Layout.preferredWidth: parent.width * 0.90

            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.NoWrap
            maximumLineCount: 1

            font.pixelSize: 12 * ScreenValues.dp

            color: "#666666"
        }
    }

    MouseArea {
        id: mouseArea

        property var originalParent

        anchors.fill: parent

        drag.target: root.dragTarget

        onClicked: root.clicked()
        onPressAndHold: root.pressAndHold(model)

        onReleased: root._newParent = (root.Drag.target !== null ? root.Drag.target : root._originalParent)

        states: [
            State {
                name: "dragging"
                when: mouseArea.drag.active

                ParentChange { target: root; parent: root._originalParent }

                AnchorChanges {
                    target: root
                    anchors {
                        verticalCenter: undefined
                        horizontalCenter: undefined
                        left: undefined
                        right: undefined
                        top: undefined
                        bottom: undefined
                    }
                }
            },
            State {
                name: "notDragging"
                when: !mouseArea.drag.active

                ParentChange { target: root; parent: root._newParent }

                AnchorChanges {
                    target: root

                    anchors {
                        verticalCenter: parent !== root._originalParent ? parent.verticalCenter : undefined
                        horizontalCenter: parent !== root._originalParent ? parent.horizontalCenter : undefined
                        left: undefined
                        right: undefined
                        top: undefined
                        bottom: undefined
                    }
                }
            }
        ]
    }
}
