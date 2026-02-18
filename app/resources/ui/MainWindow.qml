import QtQuick 2.8
import com.labcompass 1.0
import "compass"
import "instruction"

Item {
  id: root

  width: 260
  implicitWidth: Math.max(header.implicitWidth, compass.implicitWidth + toolbar.implicitWidth, instructionList.implicitWidth)
  implicitHeight: header.implicitHeight + compass.implicitHeight + instructionList.implicitHeight

  Column {
    anchors.right: parent.right
    Header {
      id: header
      objectName: "header"
      anchors.right: parent.right
    }

    Row {
      anchors.right: parent.right
      Compass {
        id: compass
      }
      Toolbar {
        id: toolbar
      }
    }

    InstructionList {
      id: instructionList
      anchors.right: parent.right
    }
  }
}
