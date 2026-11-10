import QtQuick
import labcompass
import '..'

InstructionItem {
  id: root

  property var model

  iconSource: {
    return {
      0: 'qrc:/qt/qml/labcompass/assets/images/instruction/loaded-map-normal.svg',
      1: 'qrc:/qt/qml/labcompass/assets/images/instruction/loaded-map-cruel.svg',
      2: 'qrc:/qt/qml/labcompass/assets/images/instruction/loaded-map-merciless.svg',
      3: 'qrc:/qt/qml/labcompass/assets/images/instruction/loaded-map-uber.svg'
    }[root.model.difficulty] ?? '';
  }

  Text {
    color: Styles.primaryTextColor
    //: Label displayed before the name of the loaded map
    //% "Loaded Map:"
    //@ Instruction
    text: qsTrId("id-loaded-map")
  }
  Text {
    color: Styles.primaryTextColor
    //: Text displayed under compass when player teleports to labyrinth plaza.
    //: First parameter is date (formatted using current locale)
    //: Second parameter is difficulty (Normal, Cruel, Merciless or Uber)
    //% "%1 %2"
    //@ Instruction
    text: (root.model && root.model.date && root.model.difficulty)
          ? qsTrId("id-loaded-map-text")
            .arg(root.model.date.toLocaleDateString(Qt.locale(), Locale.ShortFormat))
            .arg(qsTrId(root.getDifficultyForTranslationId(root.model.difficulty)))
          : ''
  }

  function getDifficultyForTranslationId(difficulty: int): string {
    switch(difficulty) {
      case 0:
        return "id-labyrinth-difficulty-normal";
      case 1:
        return "id-labyrinth-difficulty-cruel";
      case 2:
        return "id-labyrinth-difficulty-merciless";
      case 3:
        return "id-labyrinth-difficulty-uber";
    }
  }
}
