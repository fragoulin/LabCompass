import QtQuick 2.8
import QtQuick.Controls 2.2
import QtQuick.Shapes 1.8

ProgressBar {
  id: root

  property real circleWidth: 4
  property color color: 'black'

  background: null

  contentItem: Item {

    Rectangle {
      id: ring
      anchors.fill: parent
      anchors.margins: border.width / 2 + 1
      radius: Math.max(width, height) / 2
      color: 'transparent'
      border.width: root.circleWidth
      visible: false
    }

    Shape {
      anchors.fill: parent

      ShapePath {
          strokeWidth: 0
          strokeColor: "transparent"
          fillGradient: ConicalGradient {
            angle: 0.0
            GradientStop { position: 0; color: root.color }
            GradientStop { position: root.value; color: root.color }
            GradientStop { position: root.value + 0.001; color: 'transparent' }
            GradientStop { position: 1; color: 'transparent' }
          }
      }
    }
  }
}
