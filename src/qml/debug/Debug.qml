import QtQuick 2.0
import QtQuick.Controls
import com.iktwo.qutelauncher 1.0 as QL

/*!
    \qmltype Debug

    \brief Element that displays debug data.
*/

Item {
    id: root

    property string jsonStyle: "<style>
                                .json-key { color: #3498db; }
                                .json-value { color: #2ecc71; }
                                .json-string { color: #e67e22; }</style>"

    property var debugData

    function _replacer(match, pIndent, pKey, pVal, pEnd) {
        var key = '<span class=json-key><br>'
        var val = '<span class=json-value>'
        var str = '<span class=json-string>'
        var r = pIndent || ''

        if (pKey)
            r = r + key + pKey.replace(/[": ]/g, '') + '</span>: '

        if (pVal)
            r = r + (pVal[0] === '"' ? str : val) + pVal + '</span>'

        return r + (pEnd || '')
    }

    function prettyPrint(obj) {
        var jsonLine = /^( *)("[\w]+": )?("[^"]*"|[\w.+-]*)?([,[{])?$/mg

        var jsonString = JSON.stringify(obj, null, 2)

        if (!jsonString)
            return

        return jsonString
        .replace(/&/g, '&amp;').replace(/\\"/g, '&quot;')
        .replace(/</g, '&lt;').replace(/>/g, '&gt;')
        .replace(jsonLine, root._replacer)
        .replace("}", "<br>}")
    }

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "#000000"
        opacity: 0.2
    }

    Label {
        anchors {
            fill: parent
            margins: Math.min(root.height, root.width) * 0.02
        }

        opacity: 0.8
        color: "#95a5a6"
        textFormat: Text.RichText
        wrapMode: Text.Wrap
        font.pointSize: 22
        text: jsonStyle + prettyPrint(root.debugData)
    }
}
