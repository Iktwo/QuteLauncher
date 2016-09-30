import QtQuick 2.6
import QtQuick.Controls 1.4
import com.iktwo.qutelauncher 1.0 as QL

IntroScreen {
    id: root

    Button {
        anchors.centerIn: parent

        text: qsTr("DONE")

        onClicked: root.done()
    }
}
