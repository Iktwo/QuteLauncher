import QtQuick 2.6
import QtQuick.Controls 1.4
import com.iktwo.qutelauncher 1.0 as QL

Item {
    id: root

    signal done

    Button {
        anchors.centerIn: parent

        text: "DONE"
        onClicked: root.done()
    }
}
