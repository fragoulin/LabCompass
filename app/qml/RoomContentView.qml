import QtQuick 2.8
import labcompass

Row {
  id: root
  property var model

  spacing: 2

  Repeater {
    id: contentView
    model: root.model

    RoomContentIcon {
      content: modelData
    }
  }
}
