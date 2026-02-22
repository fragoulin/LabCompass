import QtQuick 2.8
import com.labcompass 1.0

Row {
  id: root
  spacing: 4

  signal drag(int dx, int dy)
  signal exit()

  Rectangle {
    width: text.implicitWidth + close.width
    height: 24
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
    buttonHeight: 24
  }
}
