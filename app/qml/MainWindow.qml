import QtQuick
import labcompass
import "compass"
import "instruction"

Item {
  id: root

  width: 170
  height: 170

  Column {
    anchors.right: parent.right
    spacing: 4

    Row {
      anchors.right: parent.right
      Compass {
        id: compass
        objectName: "compass"
      }
      Toolbar {
        id: toolbar
        objectName: "toolbar"
      }
    }

    InstructionList {
      id: instructionList
      anchors.right: parent.right
    }
  }

  DragHandler {
    target: root
  }
}
