import QtQuick 2.6
import com.iktwo.qutelauncher 1.0 as QL
import "."

Item {
    id: root

    property int navbarMargin: QL.ScreenValues.navBarVisible ? QL.ScreenValues.navigationBarHeight : 0
    property int statusbarMargin: QL.ScreenValues.statusBarHeight

    /// TODO: adapt this to tiles theme
    property bool opened: false

    Flickable {
        anchors.fill: parent

        contentWidth: width * 2
        boundsBehavior: Flickable.StopAtBounds
        flickableDirection: Flickable.HorizontalFlick
        maximumFlickVelocity: applicationWindow.width * 3
        pressDelay: 50

        flickDeceleration: 5000

        /// TODO: check if this is ok
        interactive: !applicationGrid.editMode

        //        property bool enableAnimation: true

        Behavior on contentX { SmoothedAnimation { duration: 150 } }

        //        onMovementStarted: {

        //        }

        onMovementEnded: {
            if (contentX >= width / 2)
                contentX = width
            else
                contentX = 0

            //console.log("CONTENT X:", contentX)
        }

        Item {
            anchors {
                top: parent.top
                bottom: parent.bottom
            }

            width: applicationWindow.width * 2

            Rectangle {
                anchors.fill: parent

                color: "black"
                opacity: 0.3
                visible: applicationGrid.editMode
            }

            ApplicationGrid {
                id: applicationGrid

                anchors {
                    top: parent.top; topMargin: parent.height * 0.025
                    bottom: parent.bottom; bottomMargin: parent.height * 0.025
                    left: parent.left; leftMargin: (parent.width / 2 ) * 0.025
                }

                model: QL.PackageManager

                width: (parent.width / 2 ) * 0.95
            }

            Rectangle {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                }

                width: parent.width / 2
                color: "black"

                ApplicationList {
                    id: applicationList

                    model: QL.PackageManager

                    onShowColorPicker: colorPicker.open()
                }
            }
        }
    }

    ApplicationMenu {
        id: menu
    }

    SectionNavigator {
        id: sectionNavigator

        onGoToSection: applicationList.goToIndex(sectionIndex)
    }

    ColorPicker {
        id: colorPicker

        /// TODO: handle back key
        onSelectedColor: Configuration.color = color
    }

    Connections {
        target: QL.Launcher
        onNewIntentReceived: explandableItem.close()
        onMinimized: explandableItem.close()
    }
}
