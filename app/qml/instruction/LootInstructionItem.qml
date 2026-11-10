import QtQuick
import labcompass
import '..'

InstructionItem {
  id: root

  property alias model: lootView.model

  iconSource: 'qrc:/qt/qml/labcompass/assets/images/instruction/loot.svg'

  Text {
    color: Styles.primaryTextColor
    //: Label displayed before the name of a loot
    //% "Loot:"
    //@ Instruction
    text: qsTrId("id-loot")
  }

  Repeater {
    id: lootView

    Grid {
      id: grid
      columns: 2
      spacing: 4
      verticalItemAlignment: Grid.AlignVCenter
      required property var modelData

      SvgImage {
        source: grid.modelData in Global.contentIconMapping ? 'qrc:/qt/qml/labcompass/assets/images/lab-content/' + Global.contentIconMapping[grid.modelData] + '.svg' : ''
        sourceSize.width: 16
        sourceSize.height: 16
      }

      Text {
        color: Styles.primaryTextColor
        text: grid.modelData in Global.nameMapping ? Global.nameMapping[grid.modelData] : grid.modelData
      }
    }
  }
}
