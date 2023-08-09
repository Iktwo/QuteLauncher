pragma Singleton
import QtQuick
import QtCore

Item {
    id: root

    property color colorGridContainer: "#f5f5f5"
    property color colorApplicationWindow: "#00000000"

    property bool portrait: false
    property bool tablet: false

    property int columns: getColumns(portrait)
    property int rows: getRows(portrait)

    property string theme: "classic"

    function getColumns(portrait) {
        if (portrait) {
            if (tablet) {
                return 5
            } else {
                return 4
            }
        } else {
            if (tablet) {
                return 6
            } else {
                return 4
            }
        }
    }

    function getRows(portrait) {
        if (portrait) {
            return 6
        } else {
            if (tablet) {
                return 5
            } else {
                return 4
            }
        }
    }

    Settings {
        property alias theme: root.theme
    }
}
