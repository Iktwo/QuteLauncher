pragma Singleton
import QtQuick 2.0
import Qt.labs.settings 1.0

Item {
    id: root

    property bool dark: true
    property color color: "green"

    Settings {
        property alias dark: root.dark
        property alias color: root.color
    }
}
