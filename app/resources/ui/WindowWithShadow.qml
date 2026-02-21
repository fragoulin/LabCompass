import QtQuick
import com.labcompass 1.0
import QtQuick.Effects

Item {
  id: root
  width: contents.width + 20
  height: contents.height + 20

  default property alias content: contents.children
  property Item root: contents
  // TODO use RectangularGlow from QT 6.10
/*
  RectangularGlow {
    x: 10
    y: 13
    width: contents.width
    height: contents.height
    glowRadius: 3
    spread: 0.0
    color: Qt.rgba(0, 0, 0, 0.8)
    cornerRadius: glowRadius
  }
*/
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
  }
}
