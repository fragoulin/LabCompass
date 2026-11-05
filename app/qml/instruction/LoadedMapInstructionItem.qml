import QtQuick
import labcompass
import '..'

InstructionItem {
  id: root

  property var model

  iconSource: {
    return {
      'Normal': 'qrc:/qt/qml/labcompass/assets/images/instruction/loaded-map-normal.svg',
      'Cruel': 'qrc:/qt/qml/labcompass/assets/images/instruction/loaded-map-cruel.svg',
      'Merciless': 'qrc:/qt/qml/labcompass/assets/images/instruction/loaded-map-merciless.svg',
      'Uber': 'qrc:/qt/qml/labcompass/assets/images/instruction/loaded-map-uber.svg',
      '': ''
    }[root.model && root.model.difficulty ? root.model.difficulty : ''];
  }

  Text {
    color: Global.primaryTextColor
    //: Label displayed before the name of the loaded map
    //% "Loaded Map:"
    //@ Instruction
    text: qsTrId("id-loaded-map")
  }
  Text {
    color: Global.primaryTextColor
    //: Text displayed under compass when player teleports to labyrinth plaza.
    //: First parameter is date (formatted using current locale)
    //: Second parameter is difficulty (Normal, Cruel, Merciless or Uber)
    //% "%1 %2"
    //@ Instruction
    text: (root.model && root.model.date && root.model.difficulty)
          ? qsTrId("id-loaded-map-text")
            .arg(root.model.date.toLocaleDateString(Qt.locale(), Locale.ShortFormat))
            .arg(qsTrId("id-labyrinth-difficulty-" + root.model.difficulty.toLowerCase()))
          : ''
  }
}
