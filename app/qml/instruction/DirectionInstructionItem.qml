import QtQuick
import labcompass

InstructionItem {
  id: root

  property string connectionType
  property string direction
  property string nextRoomName
  property bool atPlaza
  property bool nextRoomIsPreviousRoom
  property bool nextRoomIsUnmarkedOppositeDirection

  //: To next room (e.g. To Aspirant Trial). Argument is the room name
  //% "To %1 "
  //@ Instruction
  readonly property string labelToDirection: root.nextRoomName ? qsTrId(
                                                                   "id-to-next-room").arg(
                                                                   root.nextRoomName) : ""

  iconSource: connectionType == 'secret' ? 'qrc:/qt/qml/labcompass/assets/images/instruction/secret-passage.svg' : root.direction
  in Global.directionMapping ? 'qrc:/qt/qml/labcompass/assets/images/instruction/direction_'
  + root.direction + '.svg' : nextRoomIsPreviousRoom ? 'qrc:/qt/qml/labcompass/assets/images/instruction/backward.svg' : nextRoomIsUnmarkedOppositeDirection ? 'qrc:/qt/qml/labcompass/assets/images/instruction/opposite.svg' : 'qrc:/qt/qml/labcompass/assets/images/instruction/direction_unknown.svg'

  Text {
    visible: root.atPlaza
    color: Global.primaryTextColor
    //: Instruction displayed when the player location is at plaza (i.e. before choosing the labyrinth difficulty)
    //% "Enter the Labyrinth"
    //@ Instruction
    text: qsTrId("id-enter-the-labyrinth")
  }

  Text {
    visible: !root.atPlaza
    color: Global.primaryTextColor
    text: root.nextRoomIsPreviousRoom ? //: Instruction indicating to player to back to previous room (e.g. after farming a darkshrine, or a key)
                                        //% "Back to Previous Room"
                                        //@ Instruction
                                        qsTrId(
                                          "id-back-to-previous room") : root.direction
    in Global.directionMapping ? //: Direction exit (e.g. North Exit). Argument is the direction
    //% "%1 Exit"
    //@ Instruction
    qsTrId("id-direction-exit").arg(
    Global.directionMapping[root.direction].name) : connectionType == 'secret' ? //: Instruction related to the presence of a secret passage the player can use
                                                                                 //% "Secret Passage"
                                                                                 //@ Instruction
                                                                                 qsTrId('id-secret-passage') : nextRoomIsUnmarkedOppositeDirection ? //: Instruction indicating the player to use the opposite exit
                                                                                                                                                     //% "Opposite Exit"
                                                                                                                                                     //@ Instruction
                                                                                                                                                     qsTrId("id-opposite-exit") : //: Instruction indicating the player that the exit is unmarked (unknown)
                                                                                                                                                     //% "Unmarked Exit"
                                                                                                                                                     //@ Instruction
                                                                                                                                                     qsTrId("id-unmarked-exit")
  }

  Text {
    visible: !root.atPlaza
    color: Global.primaryTextColor
    text: root.nextRoomIsPreviousRoom ? '' : labelToDirection
  }
}
