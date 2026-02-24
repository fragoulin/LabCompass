import QtQuick 2.8
import labcompass

InstructionItem {
  id: root

  property string connectionType
  property string direction
  property string nextRoomName
  property bool atPlaza
  property bool nextRoomIsPreviousRoom
  property bool nextRoomIsUnmarkedOppositeDirection

  iconSource: connectionType == 'secret' ? 'qrc:/qt/qml/labcompass/assets/images/instruction/secret-passage.svg' :
              root.direction in Global.directionMapping ? 'qrc:/qt/qml/labcompass/assets/images/instruction/direction_' + root.direction + '.svg' :
              nextRoomIsPreviousRoom ? 'qrc:/qt/qml/labcompass/assets/images/instruction/backward.svg' :
              nextRoomIsUnmarkedOppositeDirection ? 'qrc:/qt/qml/labcompass/assets/images/instruction/opposite.svg' :
              'qrc:/qt/qml/labcompass/assets/images/instruction/direction_unknown.svg'

  Text {
    visible: root.atPlaza
    color: Global.primaryTextColor
    text: qsTr('Enter the Labyrinth')
  }

  Text {
    visible: !root.atPlaza
    color: Global.primaryTextColor
    text: root.nextRoomIsPreviousRoom ? qsTr('Back to Previous Room') :
                                   //: Direction exit (e.g. North Exit)
          root.direction in Global.directionMapping ? qsTr("%1 %2").arg(Global.directionMapping[root.direction].name).arg(qsTr('Exit')) :
          connectionType == 'secret' ? qsTr('Secret Passage') :
          nextRoomIsUnmarkedOppositeDirection ? qsTr('Opposite Exit') :
          qsTr('Unmarked Exit')
  }

  Text {
    visible: !root.atPlaza
    color: Global.primaryTextColor
    //: To next room (e.g. To Aspirant Trial)
    text: qsTr("%1 %2 ").arg(root.nextRoomIsPreviousRoom ? '' : qsTr('To')).arg(root.nextRoomName)
  }
}
