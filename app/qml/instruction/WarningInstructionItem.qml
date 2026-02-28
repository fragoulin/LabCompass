import QtQuick
import labcompass

InstructionItem {
  id: root

  property string text

  color: '#D32F2F'
  iconSource: 'qrc:/qt/qml/labcompass/assets/images/instruction/warning.svg'

  Text {
    width: parent.width
    wrapMode: Text.WordWrap
    text: root.text
    color: Global.primaryTextColor
  }
}
