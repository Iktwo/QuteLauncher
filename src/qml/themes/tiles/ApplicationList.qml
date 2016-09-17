import QtQuick 2.2
import QtQuick.Layouts 1.1
import com.iktwo.qutelauncher 1.0 as QL
import "."

Item {
    id: root

    property alias model: listView.model
    property int delegateHeight: dpi * 0.40

    signal showColorPicker

    function goToIndex(index) {
        listView.positionViewAtIndex(index, ListView.Beginning)
        /// Add delegateHeight to move past the section
        listView.contentY += delegateHeight
    }

    anchors.fill: parent

    ListView {
        id: listView

        anchors {
            top: listHeader.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        cacheBuffer: height * 9
        maximumFlickVelocity: root.height * 2.5

        section {
            property: "category"
            criteria: ViewSection.FirstCharacter
            delegate: ApplicationSection {
                text: section

                onClicked: sectionNavigator.open()
            }
        }

        delegate: Item {
            height: delegateHeight
            width: root.width

            Rectangle {
                anchors {
                    fill: icon
                    margins: -parent.height * 0.05
                }
                color: Configuration.color
            }

            Image {
                id: icon

                anchors {
                    left: parent.left; leftMargin: 20
                    verticalCenter: parent.verticalCenter
                    //horizontalCenter: parent.horizontalCenter
                    //top: parent.top; topMargin: parent.height * 0.2
                }

                antialiasing: true
                height: parent.height * 0.75
                width: height
                asynchronous: true
                fillMode: Image.PreserveAspectFit
                source: "image://icon/" + model.packageName
            }

            Text {
                anchors {
                    verticalCenter: icon.verticalCenter
                    left: icon.right; leftMargin: dpi * 0.06
                    right: parent.right
                }

                text: model.name
                elide: Text.ElideRight
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: packageManager.launchApplication(model.packageName)
                onPressAndHold: {
                    var mappedItem = mapToItem(root, mouse.x, mouse.y)
                    menu.packageName = model.packageName
                    menu.name = model.name
                    menu.open(mappedItem.y, mouse.x)
                }
            }
        }
    }

    Rectangle {
        id: listHeader

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
        }

        height: delegateHeight
        color: "black"
        visible: listView.contentY > delegateHeight

        ApplicationSection {
            text: listView.currentSection

            onClicked: sectionNavigator.open()
        }
    }

    Item {
        id: btnMenu

        anchors {
            top: parent.top
            right: parent.right
        }

        width: 48 * QL.ScreenValues.dp
        height: 48 * QL.ScreenValues.dp
        clip: true

        scale: mouseArea.pressed ? 0.97 : 1

        Image {
            anchors.fill: parent
            antialiasing: true
            /// TODO: verify this
            source: "qrc:/images/menu"
        }

        MouseArea {
            id: mouseArea

            anchors.fill: parent

            onClicked: root.showColorPicker()
        }
    }
}
