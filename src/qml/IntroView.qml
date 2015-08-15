import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Layouts 1.2

FocusScope {
    property alias currentIndex: listView.currentIndex
    property alias model: listView.model
    property alias progress: animationController.progress
    property alias enabled: listView.enabled
    property alias delegate: listView.delegate
    property alias view: listView
    property alias buttonsContainerHeight: buttonsContainer.height
    property alias rectangleDividerHeight: rectangleDivider.height
    property alias dragging: listView.dragging

    readonly property double xPosition: (listView.contentX / listView.width)
    readonly property bool movingLeft: listView.movingLeft

    onXPositionChanged:  {
        if (currentIndex < 0)
            return

        var result = 0

        if (listView.movingLeft)
            result = (1 - (xPosition - Math.floor(xPosition))).toFixed(2)
        else
            result = (xPosition - Math.floor(xPosition)).toFixed(2)

        if (listView.movingLeft) {
            if (xPosition > 0 && currentIndex > 0 && xPosition < currentIndex) {
                propertyAnimationBackground.to = model.get(Math.max(currentIndex - 1, 0)).backgroundColor
                propertyAnimationBackground.from = model.get(currentIndex).backgroundColor
            } else {
                propertyAnimationBackground.to = model.get(currentIndex).backgroundColor
                propertyAnimationBackground.from = model.get(Math.min(listView.count - 1, currentIndex + 1)).backgroundColor
            }
        } else {
            if (xPosition < (model.count - 1) && currentIndex < (model.count - 1) && currentIndex < xPosition) {
                propertyAnimationBackground.to = model.get(Math.min(listView.count - 1, currentIndex + 1)).backgroundColor
                propertyAnimationBackground.from = model.get(currentIndex).backgroundColor
            } else {
                propertyAnimationBackground.to = model.get(currentIndex).backgroundColor
                propertyAnimationBackground.from = model.get(Math.max(currentIndex - 1, 0)).backgroundColor
            }
        }

        if (result == 0) {
            rectangleBackground.color = model.get(currentIndex).backgroundColor
            propertyAnimationBackground.from = model.get(currentIndex).backgroundColor
        } else if (xPosition > 0 && xPosition < (model.count - 1)) {
            progress = result
        } else if (xPosition < 0) {
            progress = 0
            rectangleBackground.color = model.get(currentIndex).backgroundColor
        }
    }

    Rectangle {
        id: rectangleBackground

        anchors.fill: parent

        ColorAnimation on color { }
    }

    ListView {
        id: listView

        property double previousX

        property bool movingLeft

        anchors {
            top: parent.top
            bottom: buttonsContainer.top
            left: parent.left
            right: parent.right
        }

        model: model
        orientation: ListView.Horizontal

        snapMode: ListView.SnapToItem

        onContentXChanged: {
            if (previousX > contentX)
                movingLeft = true
            else
                movingLeft = false

            previousX = contentX
        }

        highlightRangeMode: ListView.StrictlyEnforceRange

        preferredHighlightBegin: 0
        preferredHighlightEnd: width / 2

        delegate: Rectangle {
            height: ListView.view.height
            width: ListView.view.width

            color: "transparent"

            border {
                color: "black"
                width: 1
            }
        }
    }

    Item {
        id: buttonsContainer

        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        height: 57

        Rectangle {
            id: rectangleDivider

            anchors {
                left: parent.left
                right: parent.right
            }

            height: 1

            color: "#44ffffff"
        }
    }

    AnimationController {
        id: animationController

        animation: ParallelAnimation {
            PropertyAnimation {
                id: propertyAnimationBackground

                target: rectangleBackground
                property: "color"
                from: model.count > 0 ? model.get(0).backgroundColor : "#000000"
                to: model.count > 0 ? model.get(1).backgroundColor : "#000000"

                onFromChanged: animationController.reload()
                onToChanged: animationController.reload()
            }
        }
    }
}
