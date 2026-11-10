import QtQuick
import labcompass
import QtQuick.Effects

Item {
  id: root

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
      color: Styles.backgroundColor
      radius: 8
    }

    RectangularShadow {
      anchors.fill: contents
    }
  }
}
