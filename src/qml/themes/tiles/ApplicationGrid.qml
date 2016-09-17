import QtQuick 2.2
import QtQuick.Controls 1.1
import QtGraphicalEffects 1.0
import com.iktwo.qutelauncher 1.0 as QL

GridView {
    id: root

    property bool editMode: false
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

    onCountChanged: {
        if (count == 0)
            editMode = false
    }

    delegate: Item {
        id: itemDelegate

        height: GridView.view.cellHeight
        width: GridView.view.cellWidth

        Item {
            id: container

            anchors {
                fill: parent
                margins: dpi * 0.04
            }

            scale: editMode && index == highlightedItem ? 1.2 : 1

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
            onClicked: {
                if (editMode) {
                    if (highlightedItem == index) {
                        editMode = false
                    } else {
                        highlightedItem = index
                    }
                } else {
                    QL.PackageManager.launchApplication(model.packageName)
                }
            }
            onPressAndHold: {
                highlightedItem = index
                editMode = true
            }
        }

        MouseArea {
            id: test
            anchors {
                top: parent.top
                right: parent.right
            }

            height: closeButton.height * 1.2
            width: closeButton.width * 1.2
            enabled: editMode && index == highlightedItem

            onClicked: {
                /// TODO: verify this
                //gridModel.removeApplication(model.packageName)
                if (root.count > highlightedItem)
                    highlightedItem -= 1
            }
        }

        Rectangle {
            id: closeButton

            anchors {
                right: parent.right; rightMargin: - width / 3
                top: parent.top; topMargin: - height / 3
            }

            enabled: editMode && index == highlightedItem
            visible: enabled

            width: parent.width / 4
            height: width

            radius: height / 2
            clip: true
            color: "black"

            border {
                color: "white"
                width: closeButton.width * 0.15
            }

            Rectangle {
                rotation: 45
                width: parent.width * 0.9
                height: width * 0.1
                anchors.centerIn: parent
                smooth: true
                antialiasing: true
            }

            Rectangle {
                rotation: -45
                width: parent.width * 0.9
                height: width * 0.1
                anchors.centerIn: parent
                smooth: true
                antialiasing: true
            }
        }
    }
}
