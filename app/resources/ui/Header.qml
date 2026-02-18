import QtQuick 2.8
import com.labcompass 1.0

Row {
  id: root
  spacing: 4

  signal drag(int dx, int dy)
  signal exit()

  Rectangle {
    implicitWidth: text.implicitWidth + close.width
    implicitHeight: Math.max(text.implicitHeight, close.implicitHeight)
    color: Global.lightPrimaryColor
    Text {
      id: text
      text: 'LabCompass'
      color: Global.primaryTextColor
      anchors.centerIn: parent
    }
    DragMoveArea {
      anchors.fill: parent
      onDrag: (dx, dy) => root.drag(dx, dy)
    }
  }

  ToolbarButton {
    id: close
    source: 'qrc:/images/close.svg'
    onClicked: exit()
  }
}
