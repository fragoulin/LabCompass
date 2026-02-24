import QtQuick 2.8
import labcompass
import QtQuick.Effects

Item {
  id: root

  signal itemClicked(int index)

  property int items
  property int currentItem

  property alias inactiveLayerComponent: inactiveLayerLoader.sourceComponent
  property alias activeLayerComponent: activeLayerLoader.sourceComponent

  Loader {
    id: inactiveLayerLoader
    anchors.fill: parent
  }

  Item {
    id: mask
    anchors.fill: parent
    Rectangle {
      id: rect
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      x: root.width / root.items * root.currentItem
      width: root.width / root.items
      color: root.enabled ? Global.lightPrimaryColor : Global.primaryColor
      radius: 4
      border.width: 2
      border.color: Global.lightPrimaryColor

      Behavior on x {
        NumberAnimation {
          easing.type: Easing.Bezier
          easing.bezierCurve: [0.4, 0.0, 0.2, 1.0, 1.0, 1.0]
          duration: 150
        }
      }
    }
  }

  Loader {
    id: activeLayerLoader
    anchors.fill: parent
    visible: false
  }

  MultiEffect {
    source: activeLayerLoader
    anchors.fill: parent
    maskEnabled: false
    maskSource: mask
  }

  MouseArea {
    cursorShape: Qt.PointingHandCursor
    anchors.fill: parent
    onClicked: (mouse) => root.itemClicked(Math.floor(mouse.x * root.items / root.width));
  }
}
