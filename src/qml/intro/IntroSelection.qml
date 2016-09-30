import QtQuick 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.0
import com.iktwo.qutelauncher 1.0 as QL
import components 1.0 as C

IntroScreen {
    Column {
        anchors.centerIn: parent

        Repeater {
            id: repeater

            model: ["Classic", "Tiles"]

            RadioButton {
                text: modelData
                checked: index === 0

                style: C.RadioButtonStyleDefault { }

                exclusiveGroup: exclusiveGroupTheme
            }
        }
    }

    Settings {
        id: settings

        property string theme: repeater.model[0].toLowerCase()
    }

    ExclusiveGroup {
        id: exclusiveGroupTheme
    }

    onNext: settings.theme = exclusiveGroupTheme.current.text.toLowerCase()
}
