import QtQuick

Item {
    id: root

    property int expandedWidth: width
    property int expandedHeight: 300
    property int menuXPosition: width / 2
    property int menuYPosition: height / 2
    property int screenHeight

    default property alias content: container.children

    signal closed
    signal canceled

    function open(xPosition, yPosition) {
        /// TODO: add some y offset so it's not oppened under the finger
        if (yPosition === undefined) {
            yPosition = screenHeight / 2
        }

        if (xPosition === undefined) {
            xPosition = 0
        }

        if (xPosition < width * 0.15)
            menuXPosition = width * 0.15
        else if (xPosition > width * 0.85)
            menuXPosition = width * 0.85
        else
            menuXPosition = xPosition

        menuYPosition = yPosition

        if (yPosition + expandedHeight > height * 0.93) {
            background.state = "openedUp"
        } else {
            background.state = "openedDown"
        }
    }

    function close() {
        background.state = "closed"
    }

    function cancel() {
        background.state = "closed"
        root.canceled()
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: background.state != "closed" ? 0.2 : 0
    }

    MouseArea {
        anchors.fill: parent

        enabled: background.state != "closed"

        onClicked: root.cancel()
    }

    Rectangle {
        id: background

        y: menuYPosition

        Column {
            id: container

            function close() {
                root.close()
            }

            anchors.fill: parent

            clip: true
        }

        state: "closed"

        states: [
            State {
                name: "openedDown"
                PropertyChanges { target: background; width: root.expandedWidth; height: root.expandedHeight; x: 0 }
            },
            State {
                name: "closed"
                PropertyChanges { target: background; width: 0; height: 0; x: root.menuXPosition }
            },
            State {
                name: "openedUp"
                PropertyChanges { target: background; width: root.expandedWidth; height: root.expandedHeight; x: 0; y: menuYPosition - expandedHeight }
            }
        ]

        transitions: [
            Transition {
                from: "closed"
                to: "openedDown"

                SequentialAnimation {
                    ScriptAction {
                        script: background.height = 10
                    }

                    NumberAnimation { properties: "x, width"; duration: 300; easing.type: Easing.InOutQuad }
                    NumberAnimation { properties: "height"; duration: 300; easing.type: Easing.InOutQuad }
                }
            },
            Transition {
                from: "closed"
                to: "openedUp"

                SequentialAnimation {
                    ScriptAction {
                        script: {
                            background.height = 10
                        }
                    }

                    NumberAnimation { properties: "x, width"; duration: 300; easing.type: Easing.InOutQuad }
                    ParallelAnimation {
                        NumberAnimation { properties: "y"; duration: 300; easing.type: Easing.InOutQuad }
                        NumberAnimation { properties: "height"; duration: 300; easing.type: Easing.InOutQuad }
                    }
                }
            }
        ]
    }
}
