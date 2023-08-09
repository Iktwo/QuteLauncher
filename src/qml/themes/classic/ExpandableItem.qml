import QtQuick
import com.iktwo.qutelauncher 1.0
import config 1.0 as Config

Item {
    default property alias content: itemContainer.data
    property alias color: rectangleMinizedIndicator.color
    property alias busy: transition.running

    property int minimizedHeight: Math.round(48 * ScreenValues.dp)
    property int minimizedWidth: Math.round(48 * ScreenValues.dp)

    property int targetWidth: Math.round(parent.width - (getSideMargin() * ScreenValues.dp))
    property int targetHeight: Math.round(parent.height - 8 * ScreenValues.dp)

    property point minimizedPoint: Qt.point(Math.round(parent.width / 2), Math.round(parent.height - rectangleMinizedIndicator.height - (4 * ScreenValues.dp)))
    property point centerPoint: Qt.point(Math.round(parent.width / 2), Math.round(parent.height / 2))
    property point targetPoint: Qt.point(Math.round(centerPoint.x - (targetWidth / 2)), Math.round(6 * ScreenValues.dp))

    readonly property bool isOpened: stateGroup.state === "opened"

    function close() {
        stateGroup.state = "closed"
    }

    function open() {
        stateGroup.state = "opened"
    }

    function getSideMargin() {
        if (applicationWindow.isScreenPortrait) {
            if (ScreenValues.isTablet)
                return -1 /// TODO: find right value
            else
                return 16
        } else {
            if (ScreenValues.isTablet)
                return 138
            else
                return -1 /// TODO: find right value
        }
    }

    Rectangle {
        id: rectangleMinizedIndicator

        color: Config.Theme.colorGridContainer

        width: minimizedWidth
        height: minimizedHeight

        x: minimizedPoint.x
        y: minimizedPoint.y
    }

    StateGroup {
        id: stateGroup

        state: "closed"

        states: [
            State {
                name: "closed"
                PropertyChanges {
                    target: rectangleMinizedIndicator
                    height: minimizedHeight; width: minimizedWidth
                    x: Math.round(minimizedPoint.x - (minimizedWidth / 2)); y: minimizedPoint.y
                    radius: Math.round(minimizedWidth / 2)
                }

                PropertyChanges {
                    target: itemContainer
                    opacity: 0
                }
            },
            State {
                name: "opened"
                PropertyChanges {
                    target: rectangleMinizedIndicator
                    height: targetHeight; width: targetWidth
                    x: targetPoint.x; y: targetPoint.y
                    radius: Math.round(2 * ScreenValues.dp)
                }

                PropertyChanges {
                    target: itemContainer
                    opacity: 1
                }
            }
        ]

        transitions: [
            Transition {
                id:  transition

                from: "closed"
                to: "opened"
                reversible: true
                ParallelAnimation {
                    PropertyAnimation { property: "y"; duration: 275; easing.type: Easing.InOutCubic }

                    SequentialAnimation {
                        PauseAnimation { duration: 50 }
                        ParallelAnimation {
                            PropertyAnimation { target: rectangleMinizedIndicator; properties: "height, width"; easing.type: Easing.InOutCubic; duration: 250 }
                            PropertyAnimation { target: rectangleMinizedIndicator; property: "radius"; easing.type: Easing.InOutCubic; duration: 250 }
                            PropertyAnimation { target: rectangleMinizedIndicator; property: "x"; easing.type: Easing.InOutCubic; duration: 250 }
                            SequentialAnimation {
                                PauseAnimation { duration: 150 }
                                PropertyAnimation { target: itemContainer; property: "opacity"; easing.type: Easing.InOutCubic}
                            }
                        }
                    }
                }
            }
        ]
    }

    Item {
        id: itemContainer

        anchors {
            right: rectangleMinizedIndicator.right; rightMargin: -ScreenValues.dp
            verticalCenter: rectangleMinizedIndicator.verticalCenter
        }

        width: targetWidth
        height: targetHeight
    }

    MouseArea {
        anchors.fill: parent
        enabled: stateGroup.state === "closed"
    }

    MouseArea {
        anchors.fill: rectangleMinizedIndicator
        enabled: stateGroup.state === "closed"

        onClicked: open()
    }
}
