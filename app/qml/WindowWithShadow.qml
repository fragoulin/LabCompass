import QtQuick
import labcompass
import QtQuick.Effects

Item {
  id: root
  width: contents.width + 20
  height: contents.height + 20

  default property alias content: contents.children
  property Item root: contents

  Item {
    id: contents
    x: 10
    y: 10
    width: childrenRect.x + childrenRect.width
    height: childrenRect.y + childrenRect.height

    Rectangle {
      anchors.fill: parent
      color: Global.backgroundColor
      radius: 8
    }

    RectangularShadow {
      anchors.fill: contents
      color: Qt.darker(contents.color, 1.6)
    }
  }
}
