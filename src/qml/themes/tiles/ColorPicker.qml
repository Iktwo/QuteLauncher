import QtQuick 2.6

Item {
    id: root

    property color color

    signal selectedColor()

    function open() {
        focus = true
        visible = true
    }

    function close() {
        visible = false
        // backKeyHandler.forceActiveFocus()
    }

    anchors.fill: parent
    visible: false

    Keys.onBackPressed: close()

    Rectangle {
        id: container

        property var colors: [
            "#a4c400", "#60a917", "#008a00",
            "#00aba9", "#1ba1e2", "#0050ef",
            "#6a00ff", "#aa00ff", "#f472d0",
            "#d80073", "#a20025", "#e51400",
            "#fa6800", "#f0a30a", "#e3c800",
            "#825a2c", "#6d8764", "#647687",
            "#76608a", "#87794e"
        ]

        anchors.fill: parent

        color: "black"

        GridView {
            anchors.centerIn: parent

            width: parent.width * 0.9
            height: parent.height * 0.9

            cellHeight: height / 5
            cellWidth: width / 4

            model: container.colors.length
            delegate: Item {
                height: GridView.view.cellHeight
                width: GridView.view.cellWidth

                Rectangle {
                    id: itemColor

                    anchors.centerIn: parent
                    width: parent.width * 0.9
                    height: parent.height * 0.9
                    color: container.colors[index]
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        root.color = itemColor.color
                        selectedColor()
                        close()
                    }
                }
            }
        }
    }
}
