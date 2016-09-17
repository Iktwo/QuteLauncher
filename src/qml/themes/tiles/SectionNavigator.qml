import QtQuick 2.6
import com.iktwo.qutelauncher 1.0 as QL
import "."

Item {
    id: root

    property var sections: [
        "#", "A", "B", "C", "D", "E", "F", "G",
        "H", "I", "J", "K", "L", "M", "N", "O",
        "P", "Q", "R", "S", "T", "U", "V", "W",
        "X", "Y", "Z", "%"
    ]

    property bool animationRunning: false

    signal goToSection(int sectionIndex)
    signal closed()
    signal opened()

    function open() {
        visible = true
        focus = true
        opened()
    }

    function close() {
        /// TODO: verify this
        // backKeyHandler.forceActiveFocus()
        closed()
    }

    anchors.fill: parent
    visible: false

    Keys.onBackPressed: close()

    MouseArea {
        anchors.fill: parent
        enabled: parent.visible
    }

    Rectangle {
        anchors.fill: parent
        color: "black"
        opacity: 0.6
    }

    GridView {
        id: view
        anchors {
            fill: parent
            rightMargin: parent.width * 0.025
            leftMargin: parent.width * 0.025
            topMargin: parent.width * 0.02
            bottomMargin: parent.width * 0.02
        }
        model: root.sections.length
        cellWidth: width / 4
        cellHeight: height / 7
        interactive: false
        delegate: Item {
            property bool sectionExists: QL.PackageManager.sections.indexOf(root.sections[index]) !== -1

            height: view.cellHeight
            width: view.cellWidth

            Flipable {
                id: flipable

                property bool flipped: !root.visible

                Connections {
                    target: root
                    onClosed: flipable.flipped = true
                    onOpened: flipable.flipped = false
                }

                anchors.fill: parent

                front: Rectangle {
                    anchors {
                        fill: parent
                        rightMargin: parent.width * 0.06
                        leftMargin: parent.width * 0.06
                        topMargin: parent.width * 0.06
                        bottomMargin: parent.width * 0.06
                    }

                    color: sectionExists ? Configuration.color : "black"
                    clip: true

                    Text {
                        anchors {
                            left: parent.left; leftMargin: 15
                            bottom: parent.bottom; bottomMargin: 15
                        }

                        color: "white"
                        font {
                            pointSize: 22
                            bold: true
                        }
                        text: root.sections[index]
                    }
                }

                transform: Rotation {
                    id: rotation
                    origin.x: flipable.width/2
                    origin.y: flipable.height/2
                    axis.x: 1; axis.y: 0; axis.z: 0
                    angle: 0
                }

                states: State {
                    name: "back"
                    when: flipable.flipped
                    PropertyChanges { target: rotation; angle: 180 }
                }

                transitions: Transition {
                    ParallelAnimation {
                        alwaysRunToEnd: true

                        NumberAnimation { target: rotation; property: "angle"; duration: 450; easing.type: Easing.InOutQuad }
                        SequentialAnimation {
                            ScriptAction {
                                script: root.animationRunning = true
                            }

                            PauseAnimation { duration: 300 }
                            ScriptAction {
                                script: {
                                    if (flipable.flipped)
                                        root.visible = false

                                    root.animationRunning = false
                                }
                            }
                        }
                    }
                }
            }

            MouseArea {
                anchors.fill: parent

                enabled: sectionExists && !root.animationRunning

                onClicked: {
                    root.goToSection(QL.PackageManager.indexOfSection(root.sections[index]))
                    close()
                }
            }
        }
    }
}
