import QtQuick
import labcompass
import '..'

InstructionItem {
  id: root

  property var model

  property string name: model ? model.title : ''
  property string difficulty: model ? model.difficulty : ''

  iconSource: {
    return {
      'Normal': 'qrc:/qt/qml/labcompass/assets/images/instruction/loaded-map-normal.svg',
      'Cruel': 'qrc:/qt/qml/labcompass/assets/images/instruction/loaded-map-cruel.svg',
      'Merciless': 'qrc:/qt/qml/labcompass/assets/images/instruction/loaded-map-merciless.svg',
      'Uber': 'qrc:/qt/qml/labcompass/assets/images/instruction/loaded-map-uber.svg',
      '': ''
    }[difficulty];
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
    text: root.name
  }
}
