import QtQuick
import QtQuick.VectorImage
import labcompass
import '..'

InstructionItem {
  id: root

  property alias model: lootView.model

  iconSource: 'qrc:/qt/qml/labcompass/assets/images/instruction/loot.svg'

  Text {
    color: Global.primaryTextColor
    text: qsTr('Loot:')
  }

  Repeater {
    id: lootView

    Grid {
      columns: 2
      spacing: 4
      verticalItemAlignment: Grid.AlignVCenter

      VectorImage {
        source: modelData in Global.contentIconMapping ? 'qrc:/qt/qml/labcompass/assets/images/lab-content/' + Global.contentIconMapping[modelData] + '.svg' : ''
        width: 16
        height: 16
      }

      Text {
        color: Global.primaryTextColor
        text: modelData in Global.nameMapping ? Global.nameMapping[modelData] : modelData
      }
    }
  }
}
