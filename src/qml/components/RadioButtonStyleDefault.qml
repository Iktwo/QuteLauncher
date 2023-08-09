import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Styles 1.4
import com.iktwo.qutelauncher 1.0 as QL

RadioButtonStyle {
    label: Label {
        text: control.text
        color: "#ffffff"
    }

    indicator: Rectangle {
        implicitWidth: QL.ScreenValues.dp * 16
        implicitHeight: QL.ScreenValues.dp * 16
        radius: QL.ScreenValues.dp * 9
        border {
            color: control.activeFocus ? "darkblue" : "gray"
            width: QL.ScreenValues.dp * 1
        }

        Rectangle {
            anchors {
                fill: parent
                margins: QL.ScreenValues.dp * 4
            }

            visible: control.checked
            color: "#555"
            radius: QL.ScreenValues.dp * 9
        }
    }
}
