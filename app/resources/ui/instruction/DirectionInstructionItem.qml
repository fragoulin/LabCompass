import QtQuick 2.8
import com.labcompass 1.0

InstructionItem {
  id: root

  property string connectionType
  property string direction
  property string nextRoomName
  property bool atPlaza
  property bool nextRoomIsPreviousRoom
  property bool nextRoomIsUnmarkedOppositeDirection

  iconSource: connectionType == 'secret' ? 'qrc:/images/instruction/secret-passage.svg' :
              direction in Global.directionMapping ? 'qrc:/images/instruction/direction_' + direction + '.svg' :
              nextRoomIsPreviousRoom ? 'qrc:/images/instruction/backward.svg' :
              nextRoomIsUnmarkedOppositeDirection ? 'qrc:/images/instruction/opposite.svg' :
              'qrc:/images/instruction/direction_unknown.svg'

  Text {
    visible: atPlaza
    color: Global.primaryTextColor
    text: qsTr('Enter the Labyrinth')
  }

  Text {
    visible: !atPlaza
    color: Global.primaryTextColor
    text: nextRoomIsPreviousRoom ? qsTr('Back to Previous Room') :
                                   //: Direction exit (e.g. North Exit)
          direction in Global.directionMapping ? qsTr("%1 %2").arg(Global.directionMapping[direction].name).arg(qsTr('Exit')) :
          connectionType == 'secret' ? qsTr('Secret Passage') :
          nextRoomIsUnmarkedOppositeDirection ? qsTr('Opposite Exit') :
          qsTr('Unmarked Exit')
  }

  Text {
    visible: !atPlaza
    color: Global.primaryTextColor
    //: To next room (e.g. To Aspirant Trial)
    text: qsTr("%1 %2 ").arg(nextRoomIsPreviousRoom ? '' : qsTr('To')).arg(nextRoomName)
  }
}
