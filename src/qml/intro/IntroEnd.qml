import QtQuick
import QtQuick.Controls
import com.iktwo.qutelauncher 1.0 as QL

IntroScreen {
    id: root

    Button {
        anchors.centerIn: parent

        text: qsTr("DONE")

        onClicked: root.done()
    }
}
