import QtQuick
import labcompass
import '..'

InstructionItem {
  id: root

  property alias model: lootView.model

  iconSource: 'qrc:/qt/qml/labcompass/assets/images/instruction/loot.svg'

  Text {
    color: Global.primaryTextColor
    //: Label displayed before the name of a loot
    //% "Loot:"
    //@ Instruction
    text: qsTrId("id-loot")
  }

  Repeater {
    id: lootView

    Grid {
      columns: 2
      spacing: 4
      verticalItemAlignment: Grid.AlignVCenter

      SvgImage {
        source: modelData in Global.contentIconMapping ? 'qrc:/qt/qml/labcompass/assets/images/lab-content/' + Global.contentIconMapping[modelData] + '.svg' : ''
        sourceSize.width: 16
        sourceSize.height: 16
      }

      Text {
        color: Global.primaryTextColor
        text: modelData in Global.nameMapping ? Global.nameMapping[modelData] : modelData
      }
    }
  }
}
